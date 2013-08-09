
user =
    name: ""
    list: null
    isLoggedIn: ->
        return name is ""
    login: (username,password,onSuccess,onFailure) ->
        ### Ajax request ###
        $.post("/login", {username:username,password:password}
        )
       
        .success (data) ->
            params=$.parseJSON data
            user.name = params.name
            user.list = params.list
            onSuccess(data) if typeof(onSuccess) is "function" and data isnt ""
            onFailure() if typeof(onFailure) is "function" and data is ""
        .fail -> 
            user.name = ""
            list=[]
            onFailure() if typeof(onFailure) is "function" and data is ""
    logout: (username,password,callBack) ->
        $.post("/logout"
        )
        .fail (->
            user.name = ""
            user.list=[]
            callBack() if typeof(callBack) is "function"
        )
        .success(->
            user.name = ""
            user.list=[]
            callBack() if typeof(callBack) is "function"
        )
### Dom ready ###
$(->
    user.login("maan","maan");
    $("ul").sortable();
)