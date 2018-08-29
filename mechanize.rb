class Mechanize

  def login_to_twitter(id, pass)
    page = self.get('https://twitter.com/')
    form = page.forms[1]
    form.field_with(name: "session[username_or_email]").value = id
    form.field_with(name: "session[password]").value = pass
    form.submit
    puts 'logged_in_twitter'
  end
end
