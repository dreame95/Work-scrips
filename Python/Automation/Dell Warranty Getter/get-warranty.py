"""textbox id inpEntrySelection
btn id btn-entry-select
expiratino id warrantyExpiringLabel"""
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
import time

driver = webdriver.Firefox()

driver.get("https://www.dell.com/support/home/en-us?app=products")


time.sleep(10)
driver.close()