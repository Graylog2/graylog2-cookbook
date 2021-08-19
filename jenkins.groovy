//Skip Branch Indexing builds
//unless it is the first build for that job, then run it
//update build status to previous job's status
if (currentBuild.buildCauses.toString().contains('BranchIndexingCause'))
{
  print "Build skipped due to trigger being Branch Indexing."

  if (currentBuild.previousBuild)
  {
    if(currentBuild.previousBuild.result == 'SUCCESS')
    {
       currentBuild.result = 'SUCCESS'
       return
    }
    else
    {
       currentBuild.result = 'FAILURE'
       return
    }
  }
}

pipeline
{
   agent none

   options
   {
      ansiColor('xterm')
      buildDiscarder logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '5', daysToKeepStr: '30', numToKeepStr: '30')
      timestamps()
   }

   environment
   {
       CHEF_LICENSE = 'accept'
   }

   stages
   {
      stage('Build')
      {
          agent
          {
            label 'linux'
          }
          steps
          {
            sh '''
                vagrant plugin install vagrant-vbguest
                kitchen verify openjdk-ubuntu-2004
                kitchen destroy openjdk-ubuntu-2004
                chef exec rspec
              '''
           }
       }
   }
}
