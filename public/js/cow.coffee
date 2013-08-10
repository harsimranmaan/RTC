###
    @author: Harsimran Singh Maan
    @date: August 09,2013
    @version:0.1
###
"use strict"
user =
    name: ""
    list: []
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
    ### Logs out the user ###
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
    ### Updates the list on the client and the server ###
    updateList:  (newVal,callBack)->        
        if newVal
            user.list = [] if not user.list
            user.list.push {item:newVal,done:0} 
        else
            user.list = []
            $(".item").each(->
                if $(this).hasClass("disabled") 
                    isDone = 1
                else
                    isDone = 0
                user.list.push {item:$(this).text(),done: isDone}
            )
        $.post('/update', {list:JSON.stringify user.list})
        .success (data) ->
            user.name = data.name
            user.list = data.list
            callBack(data) if typeof(callBack) is "function"
        .fail ->
            alert "An error occured while trying to update the list. Please retry after refresh."
### Adds new row to the dom ###            
appendRow= (val)->
    ###Create elements on the fly###
    $li= $ "<li></li>"
    $li.addClass 'hide'
    $deleteIcon =$("<span></span>")
    $deleteIcon.addClass 'icon delete'
    $doneIcon =$("<span></span>")
    $doneIcon.addClass 'icon done'
    ### Bind events ###

    $deleteIcon.click removeItem
    $doneIcon.click itemDone
    $holder=$("<span></span>")
    $holder.addClass 'item'
    $holder.text val
    $li.append($deleteIcon)
    .append($doneIcon)
    .append($holder)
    ### animate the show ###
    $li.appendTo($("ul"))
    .show 'slow'
### Handles add button click ###
addItem = ->
    val=$("#toDo").val().trim()
    if(val)
        user.updateList val, (data)->
            ### Check if still logged In ###
            if user.isLoggedIn()
                appendRow val
                $(".nothing").addClass 'hide'
            else
                logout()
    $("#toDo").val('');
    event.preventDefault()
    return false
### Logout the user ###
logout= ->
    user.logout();
    $(".error").addClass "hide"
    ### THe page transition effect ###
    $(".tasks").effect( 'drop', {}, 500, ->
        $(".login").effect 'slide', {direction:'right'}, 500
        $("ul").empty()
        $(".nothing").removeClass 'hide'
    )

    event.preventDefault()
    return false
### Fired when the drag is stopped###  
listUpdated= ->
    user.updateList null, ->
        logout() if not user.isLoggedIn()
### Handle the login button click ###
login= ->
    user.login $("#username").val(), $("#password").val(), loginSuccess, loginFailure
    event.preventDefault()
    return false
### Handle the list page display ###
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
    
### Handle login failure ###
loginFailure= ->
    $(".login").effect 'shake', ->
        $(".error").removeClass "hide"
### Remove the item ###
removeItem= ->
    $this=$(this)
    $this.parent().effect 'drop', ->
        $this.parent().remove()
        $(".nothing").removeClass 'hide' if $(".item").size() is 0
        user.updateList null, ->
            logout()  if not user.isLoggedIn()
### Mark an item as done ###   
itemDone= ->
    if not $(this).hasClass 'disabled'
        $(this).next().addClass 'disabled'
        $(this).addClass 'disabled'
        user.updateList null, ->
            logout()  if not user.isLoggedIn()

        
### trim whitespace ###
String.prototype.trim = ->
    return this.replace(/^\s+|\s+$/g, "");

### Dom ready ###
$(->
   
    ### Make the list sortable ###
    $("ul").sortable({
         update: listUpdated
        }
    )
    ###Populate if list is sent from server ###
    $(".item").each(->
        if $(this).hasClass("disabled") 
            isDone = 1
        else
            isDone = 0
        user.list.push {item:$(this).text(),done: isDone}
    )
    ### Bind events ###
    $("#btnAdd").click addItem
    $("#btnLogout").click logout
    $("#frmLogin").submit login
    $(".delete").click removeItem
    $(".done").click itemDone
    
)