/**
    Helper Class to perform all calculation logic for rollup fields.

    1. SUM - Trigger contexts handled - after insert, after update, after undelete, before delete
    2. COUNT - Trigger contexts handled - after insert, after update, after undelete, before delete

    @author Tomy Pallissery
*/

public without sharing class RollupFieldHelper { // Sharing - false +Ve - for business purpose we will not mark this as with sharing explaination provided in false +ve document

	private Map<String, List<RollupFieldConfig__mdt>> calculationModesMap;//key->'Synchronous','Asynchronous'
	private Set<Id> oldParents; //used in case of after update - count calculation
	private String sObjectName; //The context sobject name

	public RollupFieldHelper() {
		calculationModesMap = new Map<String, List<RollupFieldConfig__mdt>>();
		oldParents = new Set<Id>();
	}

	public void evaluateAndProcess() {
		sObjectName = TriggerHelper.getContextSObjName();

		List<RollupFieldConfig__mdt> configList = [ SELECT DeveloperName, SObjectName__c, FieldToAggregate__c, AggregateFunction__c,
														   AggregateResultField__c, CalculationMode__c, ParentReferenceField__c
						        					FROM   RollupFieldConfig__mdt 
													WHERE  SObjectName__c =:sObjectName AND IsActive__c = true WITH USER_MODE];
		if(configList.size() == 0) { return; }

		segregateCalculationModes(configList);
		handleRealtime();
		handleAsync();
	}

	private void segregateCalculationModes(List<RollupFieldConfig__mdt> configList) {
		for(RollupFieldConfig__mdt config : configList) {
			List<RollupFieldConfig__mdt> rollups = calculationModesMap.get(config.CalculationMode__c);
			if(rollups == null) {
				rollups = new List<RollupFieldConfig__mdt>();
				calculationModesMap.put(config.CalculationMode__c, rollups);
			}
			rollups.add(config);
		}
	}

	private void handleRealtime() {
		if(calculationModesMap.get('Synchronous') != null) {

			List<RollupField> fieldsToRoll = new List<RollupField>();

			for(RollupFieldConfig__mdt rollup :calculationModesMap.get('Synchronous')) {
				fieldsToRoll.add(new RollupField(rollup));
			}

			Set<String> fieldsToQuery = new Set<String>();
			Set<String> fieldsToFilter = new Set<String>();

			for(RollupField rollup : fieldsToRoll) {
				fieldsToQuery.add(rollup.parentReferenceIdField);
				fieldsToFilter.add(rollup.parentReferenceIdField);
				fieldsToQuery.add(rollup.parentRelationshipResultField);
			}

			List<String> queryFields = new List<String>(fieldsToQuery);
			List<String> filterFields = new List<String>(fieldsToFilter);

				
			Set<Id> childIds = getChildrenIdSet();
			Set<Id> childIdSanitized = new Set<Id>();
			for(Id rec : childIds){
				childIdSanitized.add(string.escapeSingleQuotes(rec));
			}


			// querying on children instead of parentIds, as a child object can have lookups
			// to different types of parent sobjects, and querying on parents will result in multiple query
			String query = ' SELECT ';
				   query += string.escapeSingleQuotes(String.join(queryFields, ','));
				   query += ' FROM ' + string.escapeSingleQuotes(sObjectName);
				   query += ' WHERE Id IN:childIdSanitized ';

			if(!Trigger.isAfter && !Trigger.isUpdate) { 
			 	if(filterFields.size() == 1) {
			   		query += ' AND ( ' + string.escapeSingleQuotes(filterFields[0]) + ' != NULL ) WITH USER_MODE';
			   	} else if (filterFields.size() > 1) {
			   		query += ' AND ( ' + string.escapeSingleQuotes(String.join(filterFields, ' != NULL OR '));
			   		query += ' != NULL ) WITH USER_MODE';
			   }
			}


			List<sObject> children = Database.query(query);  //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind

			if(children.size() == 0) {
				return;
			}

			List<sObject> parents = getParentsToUpdate(fieldsToRoll, children);
			
			TriggerHelper.skipTrigger = true;
			String objName = '';
			if(parents.size() > 0 ){
			if(String.isBlank(objName)){
				objName = parents[0].Id.getSobjectType().getDescribe().getName();
			}
				if(String.isNotBlank(objName) && AppUtils.isObjectAccessible(objName) && AppUtils.isObjectUpdateable(objName)) { //Added for SF review  
					update as user parents; //CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD
					TriggerHelper.skipTrigger = false;
				}
			}
			
		}
	}

	private Set<Id> getChildrenIdSet() {
		Set<Id> setChildrenIds = new Set<Id>();
		if((Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) && Trigger.isAfter) {
			setChildrenIds = Trigger.newMap.keySet();
		} else if(Trigger.isDelete && Trigger.isBefore) {
			setChildrenIds = Trigger.oldMap.keySet();
		}
		return setChildrenIds;
	}

	private List<sObject> getParentsToUpdate(List<RollupField> fieldsToRoll, List<sObject> children) {
		Map<Id,sObject> parentsMap = new Map<Id,sObject>();

		//creating parents map
		for(SObject child : children) {
			for(RollupField rollup : fieldsToRoll) {
				if(child.get(rollup.parentReferenceIdField) != null) {
					Id parentId = (Id)child.get(rollup.parentReferenceIdField);
					if(parentsMap.get(parentId) != null) {
						continue;
					}
					parentsMap.put(parentId, child.getSObject(rollup.parentRelationshipName));
				}
			}
		}

		//rollup calculation
		performRollup(parentsMap, children, fieldsToRoll);
		
		if(oldParents.size() > 0) { //condfition satisfies only on after update
			handleOldParentCalculations(parentsMap, children, fieldsToRoll);
		}

		return parentsMap.values();
	}

	private void handleOldParentCalculations(Map<Id,sObject> parentsMap, List<sObject> children, List<RollupField> fieldsToRoll) {
		Set<Id> setOldParentIds = new Set<Id>();

		Map<String, Set<String>> mapParentFields = new Map<String, Set<String>>();

		for(Id parentId : oldParents) { // filtering already queried parent records
			if(parentsMap.get(parentId) == null) {
				setOldParentIds.add(parentId);
			}
		}

		for(RollupField rollup : fieldsToRoll) {	//creating parent fields map, for query
			Set<String> setFields = mapParentFields.get(rollup.parentSObjectName);
			if(setFields == null) {
				setFields = new Set<String>();
				mapParentFields.put(rollup.parentSObjectName, setFields);
			}
			setFields.add(rollup.aggregateResultField);
		}

		if(setOldParentIds.size() > 0) {
			Map<String, Set<Id>> mapObjectNameToIds = new Map<String, Set<Id>>();
			for(Id parId : setOldParentIds) {
				SchemaManager.SObjectWrapper wrapper = SchemaManager.getSObject(parId);
				Set<Id> setIds = mapObjectNameToIds.get(wrapper.objectName);
				if(setIds == null) {
					setIds = new Set<Id>();
					mapObjectNameToIds.put(wrapper.objectName, setIds);
				}
				setIds.add(parId);
			}

			for(String objectName : mapObjectNameToIds.keySet()) {

				Set<String> fieldSet = mapParentFields.get(objectName);
				List<String> queryFields = new List<String>(fieldSet);
				Set<Id> idSet = mapObjectNameToIds.get(objectName);
				Set<Id> idSetSanitized = new Set<Id>();
				for(id rec : idSet){
					idSetSanitized.add(string.escapeSingleQuotes(rec));
				}
				String query = ' SELECT Id, ';
				query += string.escapeSingleQuotes(String.join(queryFields, ','));
			    query += ' FROM ' + string.escapeSingleQuotes(objectName);
			    query += ' WHERE Id IN:idSet WITH USER_MODE'; 

			    List<sObject> queriedParents = Database.query(query);  //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind

			    for(sObject sobj : queriedParents) {
			    	parentsMap.put(sobj.Id, sobj);
			    }
			}

			performOldParentsRollup(parentsMap, children, fieldsToRoll);
		}
	}

	private void performRollup(Map<Id,sObject> parentsMap, List<sObject> children, List<RollupField> fieldsToRoll) {
		for(SObject child : children) {
			for(RollupField rollup : fieldsToRoll) {
				if(child.get(rollup.parentReferenceIdField) != null) {
					Id parentId = (Id)child.get(rollup.parentReferenceIdField);
					if(parentsMap.get(parentId) == null) {
						continue;
					}

					sObject parent = parentsMap.get(parentId);
					if(rollup.aggregateFunction == 'SUM') {
						calculateSum(parent, child.Id, rollup);
					} else if(rollup.aggregateFunction == 'COUNT') {
						calculateCount(parent, child.Id, rollup);
					}
					parentsMap.put(parentId, parent);
				} else if(Trigger.isAfter && Trigger.isUpdate) {
					Id oldParentId = (Id)Trigger.oldMap.get(child.Id).get(rollup.parentReferenceIdField);

					if(oldParentId != null) {
						oldParents.add(oldParentId);
					}
				}
			}
		}
	}

	private void performOldParentsRollup(Map<Id,sObject> parentsMap, List<sObject> children, List<RollupField> fieldsToRoll) {
		for(SObject child : children) { //rollup calculation for after update old parents
			for(RollupField rollup : fieldsToRoll) {
				child = Trigger.oldMap.get(child.Id);
				if(child.get(rollup.parentReferenceIdField) != null) {
					Id parentId = (Id)child.get(rollup.parentReferenceIdField);
					if(parentsMap.get(parentId) == null || !oldParents.contains(parentId)) {
						continue;
					}

					sObject parent = parentsMap.get(parentId);
					if(rollup.aggregateFunction == 'SUM') {
						calculateSumOldParent(parent, child.Id, rollup);
					} else if(rollup.aggregateFunction == 'COUNT') {
						calculateCountOldParent(parent, child.Id, rollup);
					}
					parentsMap.put(parentId, parent);
				}
			}
		}
	}

	private void calculateCount(SObject parent, Id childId, RollupField rollup) {
		Decimal count = parent.get(rollup.aggregateResultField) == null ? 0 : (Decimal)parent.get(rollup.aggregateResultField);
		if(Trigger.isAfter) {
			if(Trigger.isInsert || Trigger.isUndelete) {
				count = count + 1;
			}

			if(Trigger.isUpdate) {
				Id oldParentId = (Id)Trigger.oldMap.get(childId).get(rollup.parentReferenceIdField);
				Id newParentId = (Id)Trigger.newMap.get(childId).get(rollup.parentReferenceIdField);

				if(newParentId != null && oldParentId != newParentId) {
					count = count + 1;
				}

				if(oldParentId != null && oldParentId != newParentId) {
					oldParents.add(oldParentId);
				}
			}
		}
		if(Trigger.isBefore) {
			if(Trigger.isDelete) { //TODO: check if we need to convert it to after delete, as delete operation may fail sometime
				count = count - 1;
			}
		}

		parent.put(rollup.aggregateResultField, count);
	}

	private void calculateCountOldParent(SObject parent, Id childId, RollupField rollup) {
		Decimal count = parent.get(rollup.aggregateResultField) == null ? 0 : (Decimal)parent.get(rollup.aggregateResultField);
		if(Trigger.isAfter && Trigger.isUpdate) {
				Id oldParentId = (Id)Trigger.oldMap.get(childId).get(rollup.parentReferenceIdField);

				if(oldParentId != null && count > 0) {
					count = count - 1;
				}
		}

		parent.put(rollup.aggregateResultField, count);
	}

	private void calculateSum(SObject parent, Id childId, RollupField rollup) {
		Decimal sum = parent.get(rollup.aggregateResultField) == null ? 0 : (Decimal)parent.get(rollup.aggregateResultField);
		if(Trigger.isAfter) {
			if(Trigger.isInsert || Trigger.isUndelete) {
				Decimal newVal = (Decimal)Trigger.newMap.get(childId).get(rollup.fieldToAggregate);
				if(newVal != null) {
					sum = sum + newVal;
				}
			} else if(Trigger.isUpdate) {
				SObject oldChild = Trigger.oldMap.get(childId);
				SObject newChild = Trigger.newMap.get(childId);
				Id oldParentId = (Id)oldChild.get(rollup.parentReferenceIdField);
				Id newParentId = (Id)newChild.get(rollup.parentReferenceIdField);

				if(newParentId != null) {
					Decimal oldVal = (Decimal)oldChild.get(rollup.fieldToAggregate);
					Decimal newVal = (Decimal)newChild.get(rollup.fieldToAggregate);
					if(newVal == null && oldVal != null && oldParentId == newParentId) {
							sum = sum - oldVal;
					} else if(newVal != null) {
						if(oldVal == null || oldParentId != newParentId) {
							sum = sum + newVal;
						} else if(oldParentId == newParentId) {
							sum = sum + (newVal - oldVal);
						}
					}
				}

				if(oldParentId != null && oldParentId != newParentId) {
					oldParents.add(oldParentId);
				}
			} 
		}

		if(Trigger.isBefore) {
			if(Trigger.isDelete) {
				Decimal oldVal = (Decimal)Trigger.oldMap.get(childId).get(rollup.fieldToAggregate);
				if(oldVal != null) {
					sum = sum - oldVal;
				}
			}
		}

		// TODO: check if we have to reset to zero if sum is negative, as there can be scenarios where there are records already existing
		//how to take approach for existing records? are we updating it before rolling out?
		parent.put(rollup.aggregateResultField, sum);
	}

	private void calculateSumOldParent(SObject parent, Id childId, RollupField rollup) {
		Decimal sum = parent.get(rollup.aggregateResultField) == null ? 0 : (Decimal)parent.get(rollup.aggregateResultField);
		if(Trigger.isAfter && Trigger.isUpdate) {
			SObject oldChild = Trigger.oldMap.get(childId);
			if(oldChild.get(rollup.parentReferenceIdField) != null) {
				Decimal oldVal = (Decimal)oldChild.get(rollup.fieldToAggregate);
				if(oldVal != null) {
					sum = sum - oldVal;
				}
			}
		}
		parent.put(rollup.aggregateResultField, sum);
	}

	/*TODO: Not Implemented */
	private void handleAsync() {
		
	}

	public with sharing class RollupField {
		public String sObjectName;	//The object on which rollup field is configured
		public String fieldToAggregate;	//Amount__c
		public String aggregateResultField; //TotalAmount__c
		public String aggregateFunction;	//SUM
		public String parentReferenceIdField;	//SampleParent__c
		public String parentRelationshipName; //SampleParent__r
		public String parentRelationshipResultField; //SampleParent__r.TotalAmount__c
		public String parentSObjectName; //Name of the parent sobject the parentReferenceIdField is pointing to

		public RollupField(RollupFieldConfig__mdt config) {
			this.sObjectName = config.SObjectName__c;
			this.fieldToAggregate = config.FieldToAggregate__c;
			this.aggregateResultField = config.AggregateResultField__c;
			this.aggregateFunction = config.AggregateFunction__c;
			this.parentReferenceIdField = config.ParentReferenceField__c;

			if(config.ParentReferenceField__c.contains('__c')) {
				this.parentRelationshipName = config.ParentReferenceField__c.replace('__c','__r');
			} else {
				this.parentRelationshipName = config.ParentReferenceField__c;
			}
			this.parentRelationshipResultField = this.parentRelationshipName + '.' + config.AggregateResultField__c;

			Schema.DescribeFieldResult dFR = SchemaManager.fetchDescribeFieldResult(config.SObjectName__c, config.ParentReferenceField__c);
			Schema.sObjectType sobjType = dFR.getReferenceTo()[0];

			//this.parentSObjectName = sobjType.getDescribe().getName();
			this.parentSObjectName = sobjType + '';
		}
	}
}