pipeline
{   
  agent any 
  environment 
  {
	registry = "rohit2522/nagp-jenkins-assignment"
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
		  steps
		  {
			   bat "docker build -t i-rohit2522-master:${BUILD_NUMBER} --no-cache -f Dockerfile ."   
		  }
	}
	stage('Container') {
		parallel{
			stage('Precontainer Check') {
				steps {
				   bat "docker rm -f c-rohit2522-master || exit 0 && docker rm c-rohit2522-master || exit 0"
					
				}
			}
			stage('Push to Dockerhub Repo') {
			  steps{
					 bat "docker tag i-rohit2522-master:${BUILD_NUMBER} ${registry}:master-${BUILD_NUMBER}"
					 bat "docker tag i-rohit2522-master:${BUILD_NUMBER} ${registry}:master-latest"
					 withDockerRegistry([credentialsId: 'DockerHub', url:"https://registry.hub.docker.com"]){
						bat "docker push ${registry}:master-${BUILD_NUMBER}"
				 		bat "docker push ${registry}:master-latest"				
							
					}
			  }
			}
		}
	}
	stage('Docker deployment') 
	{            
		 steps{
			script {
			  bat "docker run --name c-rohit2522-master -d -p 7200:8080 ${registry}:master-latest" 
			}
		}
	}
	stage('Deploy to GK8E') {
		steps{   
              bat "kubectl apply -f deployment.yaml"
        }
	}
	
  }
}
