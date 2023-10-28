from playwright.sync_api import sync_playwright
import requests
import os

def login_to_website(page, username, password):
    page.fill('input[name="j_username"]', username)
    page.fill('input[name="j_password"]', password)
    page.click('button[type="submit"]')

def create_project(project_name, jenkins_url, jenkins_cookie):
    data = {
        'name': project_name,
        'mode': 'hudson.model.FreeStyleProject',
        'from': '',
        'json': f'{{"name": "{project_name}", "mode": "hudson.model.FreeStyleProject", "from": ""}}'
    }

    headers = {
        'Host': jenkins_url,
        'Cookie': jenkins_cookie,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        'Referer': f'https://{jenkins_url}/view/all/newJob',
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-US,en;q=0.9",
    }

    try:
        response = requests.post(f'https://{jenkins_url}/view/all/createItem', data=data, headers=headers)
        return response.status_code
    except requests.exceptions.RequestException as e:
        return str(e)

def check_status_node(node_name, jenkins_url, jenkins_cookie):
    headers = {
        'Host': jenkins_url,
        'Cookie': jenkins_cookie,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-US,en;q=0.9",
    }

    try:
        response = requests.get(f'https://{jenkins_url}/computer/{node_name}', headers=headers)
        return response.status_code
    except requests.exceptions.RequestException as e:
        return str(e)

def config_project(project_name, jenkins_url, jenkins_cookie):
    data = {
        "enable": "true",
        "description": "",
        "stapler-class-bag": "true",
        "stapler-class": "org.jenkinsci.plugins.matrixauth.inheritance.InheritParentStrategy",
        "$class": "org.jenkinsci.plugins.matrixauth.inheritance.InheritParentStrategy",
        "stapler-class": "org.jenkinsci.plugins.matrixauth.inheritance.InheritGlobalStrategy",
        "$class": "org.jenkinsci.plugins.matrixauth.inheritance.InheritGlobalStrategy",
        "stapler-class": "org.jenkinsci.plugins.matrixauth.inheritance.NonInheritingStrategy",
        "$class": "org.jenkinsci.plugins.matrixauth.inheritance.NonInheritingStrategy",
        "_.daysToKeepStr": "",
        "_.numToKeepStr": "",
        "_.artifactDaysToKeepStr": "",
        "_.artifactNumToKeepStr": "",
        "stapler-class": "hudson.tasks.LogRotator",
        "$class": "hudson.tasks.LogRotator",
        "_.gitLabConnection": "",
        "includeUser": "false",
        "_.jobCredentialId": "",
        "_.count": "1",
        "_.durationName": "second",
        "hasSlaveAffinity": "on",
        "_.label": "",
        "quiet_period": "5",
        "scmCheckoutRetryCount": "0",
        "_.customWorkspace": "",
        "_.displayNameOrNull": "",
        "scm": "0",
        "stapler-class": "hudson.scm.NullSCM",
        "$class": "hudson.scm.NullSCM",
        "stapler-class": "hudson.plugins.git.GitSCM",
        "$class": "hudson.plugins.git.GitSCM",
        "_.url": "",
        "includeUser": "false",
        "_.credentialsId": "",
        "_.name": "",
        "_.refspec": "",
        "_.name": "*%2Fmaster",
        "stapler-class": "hudson.plugins.git.browser.AssemblaWeb",
        "$class": "hudson.plugins.git.browser.AssemblaWeb",
        "stapler-class": "hudson.plugins.git.browser.FisheyeGitRepositoryBrowser",
        "$class": "hudson.plugins.git.browser.FisheyeGitRepositoryBrowser",
        "stapler-class": "hudson.plugins.git.browser.KilnGit",
        "$class": "hudson.plugins.git.browser.KilnGit",
        "stapler-class": "hudson.plugins.git.browser.TFS2013GitRepositoryBrowser",
        "$class": "hudson.plugins.git.browser.TFS2013GitRepositoryBrowser",
        "stapler-class": "hudson.plugins.git.browser.BitbucketServer",
        "$class": "hudson.plugins.git.browser.BitbucketServer",
        "stapler-class": "hudson.plugins.git.browser.BitbucketWeb",
        "$class": "hudson.plugins.git.browser.BitbucketWeb",
        "stapler-class": "hudson.plugins.git.browser.CGit",
        "$class": "hudson.plugins.git.browser.CGit",
        "stapler-class": "hudson.plugins.git.browser.GitBlitRepositoryBrowser",
        "$class": "hudson.plugins.git.browser.GitBlitRepositoryBrowser",
        "stapler-class": "hudson.plugins.git.browser.GithubWeb",
        "$class": "hudson.plugins.git.browser.GithubWeb",
        "stapler-class": "hudson.plugins.git.browser.Gitiles",
        "$class": "hudson.plugins.git.browser.Gitiles",
        "stapler-class": "hudson.plugins.git.browser.GitLab",
        "$class": "hudson.plugins.git.browser.GitLab",
        "stapler-class": "hudson.plugins.git.browser.GitList",
        "$class": "hudson.plugins.git.browser.GitList",
        "stapler-class": "hudson.plugins.git.browser.GitoriousWeb",
        "$class": "hudson.plugins.git.browser.GitoriousWeb",
        "stapler-class": "hudson.plugins.git.browser.GitWeb",
        "$class": "hudson.plugins.git.browser.GitWeb",
        "stapler-class": "hudson.plugins.git.browser.GogsGit",
        "$class": "hudson.plugins.git.browser.GogsGit",
        "stapler-class": "hudson.plugins.git.browser.Phabricator",
        "$class": "hudson.plugins.git.browser.Phabricator",
        "stapler-class": "hudson.plugins.git.browser.RedmineWeb",
        "$class": "hudson.plugins.git.browser.RedmineWeb",
        "stapler-class": "hudson.plugins.git.browser.RhodeCode",
        "$class": "hudson.plugins.git.browser.RhodeCode",
        "stapler-class": "hudson.plugins.git.browser.Stash",
        "$class": "hudson.plugins.git.browser.Stash",
        "stapler-class": "hudson.plugins.git.browser.ViewGitWeb",
        "$class": "hudson.plugins.git.browser.ViewGitWeb",
        "authToken": "",
        "_.upstreamProjects": "",
        "ReverseBuildTrigger.threshold": "SUCCESS",
        "_.spec": "",
        "com-dabsquared-gitlabjenkins-GitLabPushTrigger": "on",
        "_.triggerOnPush": "on",
        "_.triggerOnMergeRequest": "on",
        "_.triggerOpenMergeRequestOnPush": "never",
        "_.triggerOnApprovedMergeRequest": "on",
        "_.triggerOnNoteRequest": "on",
        "_.noteRegex": "Jenkins please retry a build",
        "_.ciSkip": "on",
        "_.skipWorkInProgressMergeRequest": "on",
        "_.labelsThatForcesBuildIfAdded": "",
        "_.setBuildDescription": "on",
        "_.pendingBuildName": "",
        "branchFilterType": "All",
        "includeBranchesSpec": "",
        "excludeBranchesSpec": "",
        "sourceBranchRegex": "",
        "targetBranchRegex": "",
        "include": "",
        "exclude": "",
        "_.secretToken": "8a133f0428bac8ed1aa9acfe4171cd0f",
        "_.scmpoll_spec": "",
        "_.cleanupParameter": "",
        "_.externalDelete": "",
        "_.fileId": "",
        "_.targetLocation": "",
        "_.variable": "",
        "core:apply": "true",
        "json": (
            '{"enable": true, "description": "", "properties": '
            '{"stapler-class-bag": "true", "hudson-security-AuthorizationMatrixProperty": {}, '
            '"jenkins-model-BuildDiscarderProperty": {"specified": false, "": "0", "strategy": '
            '{"daysToKeepStr": "", "numToKeepStr": "", "artifactDaysToKeepStr": "", '
            '"artifactNumToKeepStr": "", "stapler-class": "hudson.tasks.LogRotator", "$class": '
            '"hudson.tasks.LogRotator"}}, "com-dabsquared-gitlabjenkins-connection-GitLabConnectionProperty": '
            '{"gitLabConnection": "", "useAlternativeCredential": false, "includeUser": "false", '
            '"jobCredentialId": ""}, "hudson-model-ParametersDefinitionProperty": {"specified": false}, '
            '"jenkins-branch-RateLimitBranchProperty$JobPropertyImpl": {}}, "concurrentBuild": false, '
            '"hasSlaveAffinity": true, "label": "", "hasCustomQuietPeriod": false, "quiet_period": "5", '
            '"hasCustomScmCheckoutRetryCount": false, "scmCheckoutRetryCount": "0", "blockBuildWhenUpstreamBuilding": false, '
            '"blockBuildWhenDownstreamBuilding": false, "hasCustomWorkspace": false, "customWorkspace": "", '
            '"displayNameOrNull": "", "scm": {"value": "0", "stapler-class": "hudson.scm.NullSCM", "$class": "hudson.scm.NullSCM"}, '
            '"com-dabsquared-gitlabjenkins-GitLabPushTrigger": {"triggerOnPush": true, "triggerToBranchDeleteRequest": false, '
            '"triggerOnMergeRequest": true, "triggerOnlyIfNewCommitsPushed": false, "triggerOnAcceptedMergeRequest": false, '
            '"triggerOnClosedMergeRequest": false, "triggerOpenMergeRequestOnPush": "never", "triggerOnApprovedMergeRequest": true, '
            '"triggerOnNoteRequest": true, "noteRegex": "Jenkins please retry a build", "ciSkip": true, "skipWorkInProgressMergeRequest": true, '
            '"labelsThatForcesBuildIfAdded": "", "setBuildDescription": true, "triggerOnPipelineEvent": false, "pendingBuildName": "", '
            '"cancelPendingBuildsOnUpdate": false, "branchFilterType": "All", "includeBranchesSpec": "", "excludeBranchesSpec": "", '
            '"sourceBranchRegex": "", "targetBranchRegex": "", "secretToken": "8a133f0428bac8ed1aa9acfe4171cd0f"}, "Submit": ""}'
        )
    }

    headers = {
        "Host": jenkins_url,
        "Cookie": jenkins_cookie,
        "Content-Type": "application/x-www-form-urlencoded",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.5938.63 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-US,en;q=0.9",
    }

    try:
        response = requests.post(f'https://{jenkins_url}/job/{project_name}/configSubmit', data=data, headers=headers)
        return response.status_code
    except requests.exceptions.RequestException as e:
        return str(e)
    
def delete_project(project_name, jenkins_url, jenkins_cookie):
    headers = {
        'Host': jenkins_url,
        'Cookie': jenkins_cookie,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-US,en;q=0.9",
    }

    try:
        response = requests.post(f'https://{jenkins_url}/job/{project_name}/doDelete', headers=headers)
        return response.status_code
    except requests.exceptions.RequestException as e:
        return str(e)
    
def update_gitlab_token(page, gitlab_token):
    page.goto(f"https://{jenkins_url}/manage/credentials/store/system/domain/_/credential/artemis_gitlab_api_token/update")
    page.click('button:has-text("Change password")')
    input_selector = 'input[name="_.apiToken"]'
    page.fill(input_selector, '')
    page.fill(input_selector, gitlab_token)
    page.click('button:has-text("Save")')
    
def update_gitlab_authenticate(page, gitlab_username, gitlab_password):
    page.goto(f'https://{jenkins_url}/manage/credentials/store/system/domain/_/credential/artemis_gitlab_admin_credentials/update')
    page.fill('input[name="_.username"]', gitlab_username)
    page.click('button:has-text("Change password")')
    input_selector = 'input[name="_.password"]'
    page.fill(input_selector, '')
    page.fill(input_selector, gitlab_password)
    page.click('button:has-text("Save")')
    
def replace_ssh_key(page, private_key): 
    page.goto(f'https://{jenkins_url}/manage/credentials/store/system/domain/_/credential/ssh_private_key_credentials_id/update')
    page.click('button:has-text("Replace")')
    private_key_input_selector = 'textarea[name="_.privateKey"]'
    page.fill(private_key_input_selector, private_key)
    page.click('button:has-text("Save")')
    
def change_build_node(page):
    page.goto(f'https://{jenkins_url}/computer/(built-in)/configure')
    page.fill('input[name="_.numExecutors"]', '0')
    page.click('button:text("Save")')


def connect_agent(page, agent_ip, node_name):
    page.goto(f'https://{jenkins_url}/manage/computer/new')

    page.fill('input[name="name"]', node_name)

    page.click('.jenkins-radio__label')
    page.click('button:text("Create")')
    
    # Fill input and choose option
    page.fill('input[name="_.numExecutors"]', '4')
    page.fill('input[name="_.remoteFS"]', '/home/jenkins/remote_agent')
    page.fill('input[name="_.labelString"]', 'docker')
    page.select_option('select[name="mode"]', 'EXCLUSIVE')
    page.select_option('.jenkins-select__input.dropdownList', 'hudson.plugins.sshslaves.SSHLauncher')
    page.fill('input[name="_.host"]', agent_ip)
    page.select_option('select[name="_.credentialsId"]', 'ssh_private_key_credentials_id')
    page.click('select:has-text("Known hosts file Verification Strategy")')
    page.keyboard.press('ArrowDown')
    page.keyboard.press('ArrowDown')
    page.keyboard.press('Enter')
    
    page.click('button:text("Save")')
    
def connect_gitlab(page, gitlab_url):
    page.goto(f'https://{jenkins_url}/manage/configure')
    
    input_selector = 'div[name="connections"] input[name="_.url"]'
    page.fill(input_selector, f'https://{gitlab_url}')

    page.click('button:text("Test connection")')
    
    page.wait_for_timeout(10000)
    
    page.click('button:text("Apply")')

if __name__ == '__main__':
    jenkins_url = os.environ.get('jenkins_url')
    gitlab_url = os.environ.get('gitlab_url')
    jenkins_username = os.environ.get('jenkins_username')
    jenkins_password = os.environ.get('jenkins_password')
    agent_ip = os.environ.get('agent_ip')
    jenkins_cookie = None
    project_name = "demo"
    gitlab_username = os.environ.get('gitlab_username')
    gitlab_password = os.environ.get('gitlab_password')
    gitlab_token = os.environ.get("gitlab_token")
    private_key = os.environ.get("private_key")

    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()
        page.goto(f'https://{jenkins_url}/login')

        login_to_website(page, jenkins_username, jenkins_password)

        cookies = page.context.cookies()
        
        for cookie in cookies:
            if "JSESSIONID" in cookie["name"]:
                jenkins_cookie = f"{cookie['name']}={cookie['value']}"
                break

        result_create_project = create_project(project_name, jenkins_url, jenkins_cookie)
        print('Create projets status:', result_create_project)

        result_create_config = config_project(project_name, jenkins_url, jenkins_cookie)
        print('Config project status:', result_create_config)

        page.goto(f'https://{jenkins_url}/job/{project_name}/config.xml')
        
        secret_token_element = page.query_selector('secretToken')
        if secret_token_element:
            secret_token_value = secret_token_element.text_content().strip('{}')
            os.system(f'gh secret set JENKINS_SECRET_TOKEN --body {secret_token_value}')   
        else:
            print('No secretToken found on the config.xml page.')
            
        update_gitlab_token(page, gitlab_token=gitlab_token)
        update_gitlab_authenticate(page, gitlab_username=gitlab_username, gitlab_password=gitlab_password)
        
        connect_gitlab(page, gitlab_url)
                
        replace_ssh_key(page, private_key)

        node_name = "Docker connect agent"

        change_build_node(page)

        connect_agent(page, agent_ip=agent_ip, node_name=node_name)

        browser.close()