def getGitBranchName() {
	return scm.branches[0].name
}
pipeline
{   
  agent any 
  environment 
  {
	registry = "rohit2522/nagp-jenkins-assignment"
	branch = getGitBranchName()
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
	stage('Push to Dockerhub Repo') {
	  steps{
			 bat "docker tag i-rohit2522-master:${BUILD_NUMBER} ${registry}:${BUILD_NUMBER}"
			 withDockerRegistry([credentialsId: 
				'Test_Docker', url:""]){
					bat "docker push ${registry}:${BUILD_NUMBER}"
			}
	  }
  }
  
	stage('Stop running containers') 
	{
	  
	  steps{
			script {
			   echo "Stop containers"
			   bat 'docker stop c-rohit2522-master || exit 0 && docker rm c-rohit2522-master || exit 0'
			}
		}
	 }

	stage('Docker deployment') 
	{    
	   environment {
		   branch = getGitBranchName()
		}         
		 steps{
			script {
			  bat "docker run -p 7100:8080 --name c-rohit2522-master ${registry}:${BUILD_NUMBER}" 
			}
		}
	}
	}
}
