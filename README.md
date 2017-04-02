# imarch
imarch app for political movements


In order to make this app work and pull updated Realm databases from an Amazon s3 bucket you will need to set up a AWS Cognito Credentials Provider. Please see the Amazon documentation here:

http://docs.aws.amazon.com/cognito/latest/developerguide/getting-credentials.html


Once you have set up your S3 bucket you can replace the identityPoolId from the code snippet below with your S3 identity pool id.

    fileprivate func loadRealmDatabase() {
        //        createLocalNotificationsForMarches()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"<replace with your own>")
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        ...  
        ...
        
