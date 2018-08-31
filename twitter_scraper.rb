class TwitterScraper
  def login_to_twitter(agent, id, pass)
    page = agent.get('https://twitter.com/')
    form = page.forms[1]
    form.field_with(name: "session[username_or_email]").value = id
    form.field_with(name: "session[password]").value = pass
    form.submit
    puts 'logged_in_twitter'
  end

  def set_scraping_url(id)
    start_date = (Time.now.beginning_of_month).to_i.to_s + "000"
    end_date = (Time.now).to_i.to_s + "999"
    export_url = "https://analytics.twitter.com/user/" + id + "/tweets/export.json?start_time=" + start_date + "&end_time=" + end_date + "&lang=ja"
    bundle_url = "https://analytics.twitter.com/user/" + id + "/tweets/bundle?start_time=" + start_date + "&end_time=" + end_date + "&lang=ja"
    [export_url, bundle_url]
  end

  def obtain_analytics_data(agent, export_url, bundle_url)
    agent.post(export_url)
    res = agent.get(bundle_url)
    analytics_data = res.body.force_encoding('utf-8')
    analytics_data
  end
end
