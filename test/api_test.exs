defmodule ApiTest do
  # Import helpers
  use ExUnit.Case

  HTTPoison.start
  test "Test get single user api call." do
    url = "https://reqres.in/api/users/2"
    #url =  "http://localhost:1"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        assert body == "{\"data\":{\"id\":2,\"email\":\"janet.weaver@reqres.in\",\"first_name\":\"Janet\",\"last_name\":\"Weaver\",\"avatar\":\"https://reqres.in/img/faces/2-image.jpg\"},\"support\":{\"url\":\"https://reqres.in/#support-heading\",\"text\":\"To keep ReqRes free, contributions towards server costs are appreciated!\"}}"
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
        flunk("404: Not found :(")
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        flunk(reason)
    end
  end
end
