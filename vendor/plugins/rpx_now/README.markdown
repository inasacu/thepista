Problem
=======
 - OpenID is complex
 - OpenID is not universally used

Solution
========
 - Use [RPX](http://rpxnow.com) for universal and usable user login
 - Make view/controller helpers for easy integration

Usage
=====
 - Get an API key @ [RPX](http://rpxnow.com)
 - Build login view
 - Communicate with RPX API in controller to create or login User
 - for more advanced features have a look at the [RPX API Docs](https://rpxnow.com/docs)

Install
=======
 - As Rails plugin: `script/plugin install git://github.com/grosser/rpx_now.git `
 - As gem: `sudo gem install grosser-rpx_now --source http://gems.github.com/`
 - As gem from source: `git clone git://github.com/grosser/rpx_now.git`,`cd rpx_now`,`rake manifest`,`rake install`

Examples
========

View
----
    #login.erb
    #here 'mywebsite' is your subdomain/realm on RPX
    <%=RPXNow.embed_code('mywebsite',rpx_token_sessions_url)%>
    OR
    <%=RPXNow.popup_code('Login here...','mywebsite',rpx_token_sessions_url,:language=>'de')%>

Controller
----------
    # simple: use defaults
    # user_data returns e.g. {:name=>'John Doe',:email=>'john@doe.com',:identifier=>'blug.google.com/openid/dsdfsdfs3f3'}
    # when no user_data was found (invalid token supplied), data is empty, you may want to handle that seperatly...
    # your user model must have an identifier column
    def rpx_token
      data = RPXNow.user_data(params[:token],'YOUR RPX API KEY')
      self.current_user = User.find_by_identifier(data[:identifier]) || User.create!(data)
      redirect_to '/'
    end

    # process the raw response yourself:
    RPXNow.user_data(params[:token],'YOUR RPX API KEY'){|raw| {:email=>raw['profile']['verifiedEmail']}}

    # request extended parameters (most users and APIs do not supply them)
    RPXNow.user_data(params[:token],'YOUR RPX API KEY',:extended=>'true'){|raw| ...have a look at the RPX API DOCS...}

    # you can provide the api key once, and leave it out on all following calls
    RPXNow.api_key = 'YOUR RPX API KEY'
    RPXNow.user_data(params[:token],:extended=>'true')

Advanced: Mappings
------------------
You can map your primary keys (e.g. user.id) to identifiers, so that  
users can login to the same account with multiple identifiers.
    #add a mapping
    RPXNow.map(identifier,primary_key,'YOUR RPX API KEY')

    #remove a mapping
    RPXNow.unmap(identifier,primary_key,'YOUR RPX API KEY')

    #show mappings
    RPXNow.mappings(primary_key,'YOUR RPX API KEY') # [identifier1,identifier2,...]

After a primary key is mapped to an identifier, when a user logs in with this identifier,  
`RPXNow.user_data` will contain his `primaryKey` as `:id`.

TODO
====
 - remove activesupport dependency, use something smaller (json gem looks good but: JSON.parse("{x:1}")==BOOM)
 - validate RPXNow.com SSL certificate

Author
======
Michael Grosser  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...  