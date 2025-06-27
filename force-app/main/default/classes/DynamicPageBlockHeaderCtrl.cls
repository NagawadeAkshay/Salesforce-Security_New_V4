/*
	Controller class used by DynamicPageBlockHeader component
	to display the header elements for a given page block.
	It displays the following elements:
		- Page block title
		- Help text
		- Layout setup link for admin
	
	**********************************************************
	Audit History
	**********************************************************
	4/27/2013   Shah Kadirmohideen	  Created
	**********************************************************  
*/ 
global with sharing class DynamicPageBlockHeaderCtrl {
	public Boolean showAdminSetupLink {get; set;}
	
	global DynamicPageBlockHeaderCtrl() {
	}

	public static Map<String, String> getDynamicPageBlockHeaderIcon(){

		map<string,string> DynamicPageBlockHeaderIconMap = new map<string,string>();
		DynamicPageBlockHeaderIconMap.put('fa fa-pencil','utility:edit');
		DynamicPageBlockHeaderIconMap.put('fa fa-arrow','utility:right');
		DynamicPageBlockHeaderIconMap.put('fa fa-ban','utility:close');
		DynamicPageBlockHeaderIconMap.put('fa fa-bolt','utility:thunder');
		DynamicPageBlockHeaderIconMap.put('fa fa-check','utility:success'); 
		DynamicPageBlockHeaderIconMap.put('fa fa-clone','utility:clone');
		DynamicPageBlockHeaderIconMap.put('fa fa-close','utility:close');
		DynamicPageBlockHeaderIconMap.put('fa fa-cloud-download','utility:download');
		DynamicPageBlockHeaderIconMap.put('fa fa-cloud-upload','utility:upload');
		DynamicPageBlockHeaderIconMap.put('fa fa-comments','utility:chat');
		DynamicPageBlockHeaderIconMap.put('fa fa-exchange','utility:exchange');
		DynamicPageBlockHeaderIconMap.put('fa fa-external-link','utility:open');
		DynamicPageBlockHeaderIconMap.put('fa fa-eye','utility:preview');
		DynamicPageBlockHeaderIconMap.put('fa fa-file','utility:page');
		DynamicPageBlockHeaderIconMap.put('fa fa-file-pdf','utility:file_pdf');
		DynamicPageBlockHeaderIconMap.put('fa fa-file-text','utility:file');
		DynamicPageBlockHeaderIconMap.put('fa fa-gavel','utility:thunder');
		DynamicPageBlockHeaderIconMap.put('fa fa-level-up','utility:up');
		DynamicPageBlockHeaderIconMap.put('fa fa-money','utility:currency');
		DynamicPageBlockHeaderIconMap.put('fa fa-play','utility:play');
		DynamicPageBlockHeaderIconMap.put('fa fa-plus-circle','utility:add');
		DynamicPageBlockHeaderIconMap.put('fa fa-reply','utility:back');
		DynamicPageBlockHeaderIconMap.put('fa fa-share','utility:share');
		DynamicPageBlockHeaderIconMap.put('fa fa-share-square-o','utility:share_post');
		DynamicPageBlockHeaderIconMap.put('fa fa-sign-in','utility:login');
		DynamicPageBlockHeaderIconMap.put('fa fa-sign-out','utility:logout');
		DynamicPageBlockHeaderIconMap.put('fa fa-sitemap','utility:hierarchy');
		DynamicPageBlockHeaderIconMap.put('fa fa-sticky-note','utility:note');
		DynamicPageBlockHeaderIconMap.put('fa fa-stop','utility:stop');
		DynamicPageBlockHeaderIconMap.put('fa fa-tags','utility:tags');
		DynamicPageBlockHeaderIconMap.put('fa fa-times','utility:close');
		DynamicPageBlockHeaderIconMap.put('fa fa-trash','utility:delete');
		DynamicPageBlockHeaderIconMap.put('fa fa-trophy','custom:custom48');
		DynamicPageBlockHeaderIconMap.put('fa fa-undo','utility:undo');
		DynamicPageBlockHeaderIconMap.put('fa fa-unlock','utility:unlock');
		DynamicPageBlockHeaderIconMap.put('fa fa-paper-plane-o','utility:send');
		DynamicPageBlockHeaderIconMap.put('glyphicon glyphicon-pencil','utility:edit');
		DynamicPageBlockHeaderIconMap.put('glyphicon glyphicon-remove','utility:close');
		DynamicPageBlockHeaderIconMap.put('glyphicon glyphicon-send','utility:send');
		DynamicPageBlockHeaderIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
		DynamicPageBlockHeaderIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
		DynamicPageBlockHeaderIconMap.put('glyphicon glyphicon-trash','utility:delete');
		DynamicPageBlockHeaderIconMap.put('fa fa-history','utility:skip_back');
		DynamicPageBlockHeaderIconMap.put('fa fa-table','utility:table');
		DynamicPageBlockHeaderIconMap.put('fa fa-coffee','utility:coffee');
		DynamicPageBlockHeaderIconMap.put('fa fa-cubes','utility:cubes');
		DynamicPageBlockHeaderIconMap.put('fa fa-star','utility:favorite');
		DynamicPageBlockHeaderIconMap.put('fa fa-exclamation-triangle','utility:warning');
		DynamicPageBlockHeaderIconMap.put('fa fa-line-chart','utility:lineChart');
		DynamicPageBlockHeaderIconMap.put('fa fa-comment','utility:comments');
		DynamicPageBlockHeaderIconMap.put('fa fa-caret-square-o-down','utility:down');
		DynamicPageBlockHeaderIconMap.put('fa fa-wrench','utility:settings');
		DynamicPageBlockHeaderIconMap.put('fa fa-share-square-o','utility:share');
		DynamicPageBlockHeaderIconMap.put('fa fa-bolt','utility:lightning');
		DynamicPageBlockHeaderIconMap.put('fa fa-trash-o','utility:delete');
		DynamicPageBlockHeaderIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
		DynamicPageBlockHeaderIconMap.put('fa fa-file-text-o','utility:contract_doc');
		DynamicPageBlockHeaderIconMap.put('fa fa-wechat','utility:chat');
		DynamicPageBlockHeaderIconMap.put('fa fa-paperclip','utility:attach');
		DynamicPageBlockHeaderIconMap.put('fa fa-usd','utility:moneybag');
		DynamicPageBlockHeaderIconMap.put('glyphicon glyphicon-tasks','utility:task');
		//DynamicPageBlockHeaderIconMap.put('fa fa-trophy','utility:funding_award_adjustment');
		DynamicPageBlockHeaderIconMap.put('fa fa-folder','utility:open_folder');
		DynamicPageBlockHeaderIconMap.put('fa fa-paper-plane-o','utility:send');
		DynamicPageBlockHeaderIconMap.put('fa fa-play','utility:play');
	
		return DynamicPageBlockHeaderIconMap;
	}
	
	public static Map<String, String> getDynamicPageBlockHeaderIconLwc(){
	
		map<string,string> DynamicPageBlockHeaderIconMaplwc = new map<string,string>();
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-pencil','utility:edit');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-arrow','utility:right');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-ban','utility:error');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-bolt','utility:thunder');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-check','utility:success'); 
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-clone','utility:clone');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-close','utility:close');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-cloud-download','utility:download');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-cloud-upload','utility:upload');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-comments','utility:chat');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-exchange','utility:exchange');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-external-link','utility:open');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-eye','utility:preview');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-file','utility:page');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-file-text','utility:file');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-gavel','utility:thunder');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-level-up','utility:up');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-money','utility:currency');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-play','utility:play');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-plus-circle','utility:add');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-reply','utility:back');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-share','utility:share');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-share-square-o','utility:share_post');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-sign-in','utility:login');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-sign-out','utility:logout');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-sticky-note','utility:note');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-stop','utility:stop');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-tags','utility:tags');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-times','utility:close');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-trash','utility:delete');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-trophy','custom:custom48');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-undo','utility:undo');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-unlock','utility:unlock');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-paper-plane-o','utility:send');
		DynamicPageBlockHeaderIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
		DynamicPageBlockHeaderIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
		DynamicPageBlockHeaderIconMaplwc.put('glyphicon glyphicon-send','utility:send');
		DynamicPageBlockHeaderIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
		DynamicPageBlockHeaderIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
		DynamicPageBlockHeaderIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-history','utility:skip_back');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-table','utility:table');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-coffee','utility:coffee');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-cubes','utility:cubes');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-star','utility:favorite');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-line-chart','utility:graph');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-comment','utility:comments');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-wrench','utility:settings');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-share-square-o','utility:share');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-bolt','utility:lightning');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-trash-o','utility:delete');
		DynamicPageBlockHeaderIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-wechat','utility:chat');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-paperclip','utility:attach');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-usd','utility:moneybag');
		DynamicPageBlockHeaderIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
		//DynamicPageBlockHeaderIconMaplwc.put('fa fa-trophy','utility:funding_award_adjustment');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-folder','utility:open_folder');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-paper-plane-o','utility:send');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-play','utility:play');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
		DynamicPageBlockHeaderIconMaplwc.put('fa fa-male','utility:user');
	
		return DynamicPageBlockHeaderIconMaplwc;
	}
		
		

}