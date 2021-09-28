from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import time
import keyring

options = Options()
options.add_argument('--headless')
driver = webdriver.Chrome(chrome_options=options)
password = keyring.get_password("support","automator")

driver.get("https://support.wmh.com/admin")
actions = ActionChains(driver)
actions.send_keys('automator')
actions.send_keys(Keys.TAB)
actions.send_keys(keyring.get_password("support","automator"))
actions.send_keys(Keys.ENTER)
actions.perform()
time.sleep(2)
driver.get("https://support.wmh.com/adminui/servicedesk_dashboard.php")
time.sleep(2)
tickets = driver.find_element_by_class_name("k-dashboard-bignumber")
print(tickets.text)
time.sleep(2)
f = open("tickets.txt", "w")
f.write(str(tickets.text))
f.close()


driver.close()




