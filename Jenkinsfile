def tagAndPush(String localImage, String repo, String registry, String credential){
    docker.withRegistry(registry, credential){
        sh "docker tag ${localImage} ${repo}"
        sh "docker tag ${localImage} ${repo}:${BUILD_NUMBER}"
        sh "docker tag ${localImage} ${repo}:${APP_SEMANTIC_VERSION}"
        sh "docker push ${repo}"
        sh "docker push ${repo}:${BUILD_NUMBER}"
        sh "docker push ${repo}:${APP_SEMANTIC_VERSION}"
    }
}

pipeline {
    agent {
        kubernetes {
            defaultContainer 'pnpm'
            yamlFile 'agent.yaml'
        }
    }
    environment{
        IMAGE_NAME = 'tarea-final'
        DH_REPO = 'dromerocl/tara-final'
        GH_REPO = 'ghcr.io/dromerop/tara-final'
        K8S_NAMESPACE = 'ns-daniel-romero'
    }
    stages {
        stage('CI - pnpm'){
            stages {
                stage('CI - Configuracion de pnpm y node'){
                    steps {
                        container('pnpm'){
                            sh '''
                                pnpm runtime set node 24 -g
                                node --version
                                pnpm --version
                            '''
                        }
                    }
                }
                stage('CI - Instalacion de dependencias'){
                    steps {
                        container('pnpm'){
                            sh '''
                                pnpm install --frozen-lockfile
                            '''
                        }
                    }
                }
                stage('CI - Revsion de linter'){
                    steps {
                        container('pnpm'){
                            sh '''
                                pnpm lint
                            '''
                        }
                    }
                }
                stage('CI - Revision de linter'){
                    steps {
                        container('pnpm'){
                            sh '''
                                pnpm test
                            '''
                        }
                    }
                }
                stage('CI - Ejecucion del build'){
                    steps {
                        container('pnpm'){
                            sh '''
                                pnpm build
                            '''
                        }
                    }
                }
                stage('CI - Obtener semver'){
                    steps{
                        container('pnpm'){
                            script {
                                env.APP_SEMANTIC_VERSION = sh(
                                        script: '''
                                        node -p "require('./package.json').version"
                                    ''',
                                        returnStdout:true
                                ).trim()
                                echo "Version semantica detectada : ${env.APP_SEMANTIC_VERSION}"
                            }
                        }
                    }
                }
            }
        }
    }
}