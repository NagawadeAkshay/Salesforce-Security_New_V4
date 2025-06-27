/**
 * Created by REI on 17-06-2020.
 */


public with sharing class DeploymentManagerMockTest implements WebServiceMock{
    public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType){
        MetadataService.checkDeployStatusResponse_element response_x =
                new MetadataService.checkDeployStatusResponse_element();
        response_x.result = new MetadataService.DeployResult();
        response_x.result.status = 'Completed';
        response_x.result.success = true;
        response_x.result.done = true;
        response.put('response_x',(Object)response_x);
    }
}