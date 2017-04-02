# imarch
imarch app for political movements


In order to make this app work so it pulls from an Amazon s3 bucket you will need to set up a 

    fileprivate func loadRealmDatabase() {
        //        createLocalNotificationsForMarches()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"<replace with your own>")
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        ...  
        ...
        
  Please see the Amazon documentation here:
  
  http://docs.aws.amazon.com/cognito/latest/developerguide/getting-credentials.html
