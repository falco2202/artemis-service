from playwright.sync_api import sync_playwright
import requests
import time
import os

def login_to_gitlab(page, username, password):
    """
    Log in to GitLab using the provided username and password.

    Args:
        page: The page object for interacting with the GitLab login page.
        username (str): The GitLab username for logging in.
        password (str): The GitLab password for logging in.

    Returns:
        None
    """
    page.fill('input[name="user[login]"]', username)
    page.fill('input[name="user[password]"]', password)
    page.click('button[type="submit"]')


def create_token(gitlab_url, name, scope):
    """
    Create a personal access token on GitLab with the specified name and scope.

    Args:
        gitlab_url (str): The base GitLab URL.
        name (str): The name for the personal access token.
        scope (str): The scopes for the personal access token.

    Returns:
        str: The generated personal access token, or an empty string if an error occurs.
    """
    try:
        page.goto(f'https://{gitlab_url}/-/profile/personal_access_tokens?name={name}&scopes={scope}')
        page.click('button[type="button"][data-testid="add-new-token-button"]')
        page.click('button[type="button"][data-testid="clear-button"]')
        page.click('button[type="submit"][data-qa-selector="create_token_button"]')

        # Show token
        page.get_by_test_id('success-message').get_by_test_id('toggle-visibility-button').click()

        personal_access_token = page.eval_on_selector(
            'input[id="new-access-token"]',
            'input => input.value'
        )

        return personal_access_token
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return ''


def check_health(url, interval=60, timeout=5, retries=3, start_period=240):
    """
    Check the health of a service by making HTTP requests to the specified URL.

    Args:
        url (str): The URL to check for health.
        interval (int): Time interval between health checks in seconds (default is 60 seconds).
        timeout (int): Timeout for each HTTP request in seconds (default is 5 seconds).
        retries (int): Number of retries before declaring the service as unhealthy (default is 3).
        start_period (int): Time to wait before the first health check (default is 240 seconds).

    Returns:
        bool: "True" if the service is healthy, "False" if it's not.
    """
    retries_left = retries
    url = f"https://{url}/users/sign_in"

    # Wait for the start period before the first health check
    time.sleep(start_period)

    while retries_left > 0:
        try:
            response = requests.get(url, timeout=timeout)
            if response.status_code == 200:
                return True
        except requests.RequestException:
            pass

        time.sleep(interval)
        retries_left -= 1

    return False


if __name__ == '__main__':
    gitlab_url = os.environ.get('gitlab_url')
    gitlab_username = os.environ.get('gitlab_username')
    gitlab_password = os.environ.get('gitlab_password')

    if check_health(gitlab_url, start_period=5, interval=120, retries=15):
        print("Healthy")
        with sync_playwright() as p:
            browser = p.chromium.launch()
            page = browser.new_page()
            page.goto(f'https://{gitlab_url}/users/sign_in')
            login_to_gitlab(page, gitlab_username, gitlab_password)

            # Create token for artemis
            token_artemis = create_token(gitlab_url, "Artemis Admin Token", "api,read_api,read_user,read_repository,write_repository,sudo")

            # Create token for Jenkins
            token_jenkins = create_token(gitlab_url, "Jenkins", "api,read_repository")

            os.system(f'gh secret set TOKEN_ARTEMIS --body {token_artemis}')
            os.system(f'gh secret set TOKEN_JENKINS --body {token_jenkins}')

            browser.close()
    else:
        print("Unhealthy")