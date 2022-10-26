defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  test "Test javascript alerts" do
    try do
      navigate_to "https://the-internet.herokuapp.com/javascript_alerts"

      # Test JS alert opens and displays correct text.
      button = find_element(:xpath, "/html/body/div[2]/div/div/ul/li[1]/button")
      click(button)
      assert dialog_text() == "I am a JS Alert"
      accept_dialog()
      result = find_element(:id, "result")
      assert visible_text(result) == "You successfully clicked an alert"

      # Test JS confirm opens, click ok and displays correct text.
      button = find_element(:xpath, "/html/body/div[2]/div/div/ul/li[2]/button")
      click(button)
      assert dialog_text() == "I am a JS Confirm"
      accept_dialog()
      result = find_element(:id, "result")
      assert visible_text(result) == "You clicked: Ok"

      # Test JS confirm opens click cancel and displays correct text.
      button = find_element(:xpath, "/html/body/div[2]/div/div/ul/li[2]/button")
      click(button)
      assert dialog_text() == "I am a JS Confirm"
      dismiss_dialog()
      result = find_element(:id, "result")
      assert visible_text(result) == "You clicked: Cancel"

      # Test JS prompt opens, takes text and displays correct text.
      button = find_element(:xpath, "/html/body/div[2]/div/div/ul/li[3]/button")
      click(button)
      assert dialog_text() == "I am a JS prompt"
      input_into_prompt("Boo xpath!")
      accept_dialog()
      result = find_element(:id, "result")
      assert visible_text(result) == "You entered: Boo xpath!"
    catch
      _kind, error ->
        take_screenshot("screenshots/jsFail.png")
        raise error
    end
  end

  test "Test dynamic controls" do
    try do
      navigate_to "https://the-internet.herokuapp.com/dynamic_controls"

      # Test checkbox functionality.
      checkbox = find_element(:xpath, "/html/body/div[2]/div/div[1]/form[1]/div/input")
      click(checkbox)
      assert selected?(checkbox) == true

      # Check to see if checkbox was removed.
      click(find_element(:xpath, "/html/body/div[2]/div/div[1]/form[1]/button"))
      Process.sleep(1000)
      assert visible_text(find_element(:id, "message")) == "It's gone!"
      # Add checkbox back and click it.
      click(find_element(:xpath, "/html/body/div[2]/div/div[1]/form[1]/button"))
      Process.sleep(1000)
      checkbox = find_element(:id, "checkbox")
      click(checkbox)
      assert selected?(checkbox) == true

      # Test enable/disable of prompt.
      # Enable input
      click(find_element(:xpath, "/html/body/div[2]/div/div[1]/form[2]/button"))
      Process.sleep(1000)
      assert visible_text(find_element(:id, "message")) == "It's enabled!"
      input = find_element(:xpath, "/html/body/div[2]/div/div[1]/form[2]/input")
      input_into_field(input, "Needs more ID's!")
      # Disable input
      click(find_element(:xpath, "/html/body/div[2]/div/div[1]/form[2]/button"))
      Process.sleep(1000)
      assert visible_text(find_element(:id, "message")) == "It's disabled!"

    catch
      _kind, error ->
        take_screenshot("screenshots/dynamicFail.png")
        raise error
    end
  end

  test "Form Authentication" do
    try do
      navigate_to "https://the-internet.herokuapp.com/login"

      # Test empty login
      login = find_element(:xpath, "/html/body/div[2]/div/div/form/button")
      click(login)
      Process.sleep(1000)
      assert visible_text(find_element(:id, "flash")) == "Your username is invalid!\n×"

      # Login and verify it worked
      user = find_element(:id, "username")
      input_into_field(user, "tomsmith")

      pass = find_element(:id, "password")
      input_into_field(pass, "SuperSecretPassword!")

      login = find_element(:xpath, "/html/body/div[2]/div/div/form/button")
      click(login)
      Process.sleep(1000)
      assert visible_text(find_element(:id, "flash")) == "You logged into a secure area!\n×"

      # Logout
      logout = find_element(:xpath, "/html/body/div[2]/div/div/a")
      click(logout)
      assert visible_text(find_element(:id, "flash")) == "You logged out of the secure area!\n×"

    catch
      _kind, error ->
        take_screenshot("screenshots/authFail.png")
        raise error
    end
  end
end
