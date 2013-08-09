"use strict"
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
            user.name = data.name
            user.list = data.list
            onSuccess(data) if typeof(onSuccess) is "function" and data.name isnt ""
            onFailure() if typeof(onFailure) is "function" and data.name is ""
        .fail -> 
            user.name = ""
            list=[]
            onFailure() if typeof(onFailure) is "function"
    logout: (callBack) ->
        $.post("/logout")
        .success(->
            user.name = ""
            user.list=[]
            callBack() if typeof(callBack) is "function"
        )
        .fail(->
            user.name = ""
            user.list=[]
            callBack() if typeof(callBack) is "function"
        )
        
appendRow= (val)->
    $li= $ "<li></li>"
    $li.text val
    $("ul").append $li

addItem = ->
    val=$("#toDo").val().trim()
    if(val)
        appendRow val
    $("#toDo").val('');
    event.preventDefault()
    return false
logout= ->
    user.logout();
    $(".error").addClass "hide"
    $(".tasks").effect( 'drop', {}, 500, ->
        $(".login").effect 'slide', {direction:'right'}, 500
        $("ul").empty()
        $(".nothing").removeClass 'hide'
    )

    event.preventDefault()
    return false
    
    
login= ->
    user.login $("#username").val(), $("#password").val(), loginSuccess, loginFailure
    event.preventDefault()
    return false

loginSuccess= ->
    $(".error").addClass "hide"
    $(".name").text user.name
    $(".nothing").addClass 'hide' if user.list.length
    $.each(user.list, (index, value) ->
        appendRow value.item
    )
    $(".login").effect( 'drop', {}, 500, ->
        $(".tasks").effect 'slide', {direction:'right'}, 500
        $("input").each( ->
            this.value = ''
        )
    )
    

loginFailure= ->
    $(".login").effect 'shake', ->
        $(".error").removeClass "hide"
        
### trim whitespace ###
String.prototype.trim = ->
    return this.replace(/^\s+|\s+$/g, "");

### Dom ready ###
$(->
   
    ### Make the list sortable ###
    $("ul").sortable();
    $("#btnAdd").click addItem
    $("#btnLogout").click logout
    $("#frmLogin").submit login
)