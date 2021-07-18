def getGitBranchName() {
	return scm.branches[0].name
}
pipeline
{   
      agent any 
      environment 
      {       
        dockerImage = ''
      }
      tools
      {
         maven 'Maven3'
      }     
      options
      {
          skipDefaultCheckout()
          disableConcurrentBuilds()
      }
      stages
      {
         stage ('Checkout')
         {
            steps
            {
               echo "build in master branch - 1"
			   checkout scm
               
            }
         }
         stage ('Build')
         {
            steps
            {
               echo "build in master branch - 2"
               bat "mvn clean install -Dhttps.protocols=TLSv1.2"
            }
         }
         stage ('Unit Testing')
         {
            steps
            {
               bat "mvn test"
            }
         }
         stage ('Sonar Analysis')
         {
            environment 
            {
               jdk = tool name: 'JAVA_HOME'
               JAVA_HOME = "${jdk}"
               scannerHome = tool name: 'SonarQubeScanner'
            }
            steps
            {
               withSonarQubeEnv("Test_Sonar")
               {
                  bat "mvn sonar:sonar -Dhttps.protocols=TLSv1.2"
               }
            }

         }
          stage('Docker image') 
              {
                 environment {
                   buildNumber  =  "$BUILD_NUMBER"
                   branch = getGitBranchName()
                   registry = "rohit2522/nagp-jenkins-assignment/i-rohit2522-master"
                }
                  steps
                  {
                       bat 'docker build -t '+ registry + ":$BUILD_NUMBER" + " . "  + '--no-cache'
                  }
              }
         stage('Push to DTR') {
                  environment {
                   registry = "rohit2522/nagp-jenkins-assignment/i-rohit2522-master" + "$BUILD_NUMBER"
                }
                  steps{
                          bat 'docker push '+registry
                  }
              }
      
         stage('Stop running containers') 
        {
          
          steps{
                script {
                   echo "Stop containers"
                   bat 'docker stop c-rohit2522/nagp-jenkins-assignment || exit 0 && docker rm c-rohit2522/nagp-jenkins-assignment || exit 0'
                }
            }
         }

        stage('Docker deployment') 
        {    
           environment {
               branch = getGitBranchName()
               registry = "rohit2522/nagp-jenkins-assignment/i-rohitsharma-master"
            }         
             steps{
                script {
                  bat 'docker run -p 7100:8080 --name c-rohitsharma-master '+ registry + ":$BUILD_NUMBER" 
                }
            }
        }
   
      }
}
