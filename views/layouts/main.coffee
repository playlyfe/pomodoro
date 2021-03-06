define [
  'cs!modules/core'
  'cs!views/welcome'
  'cs!views/login'
  'cs!views/timer'
  'cs!models/timer'
  'playlyfe'
  'rdust!templates/layouts/main'
], (Core, WelcomeView, LoginView, TimerView, Timer, Playlyfe) ->

  MainLayout = Core.Layout.extend

    template: 'rdust!templates/layouts/main'

    events:
      'click #logout': 'logout'

    initialize: () ->
      Core.Events.on 'player:load', @render, @
      Core.Events.on 'start-task', @viewTimer, @
      Core.Events.on 'stop-timer', @viewWelcome, @
      Playlyfe.onStatusChange @render, @
      return

    cleanup: () ->
      Core.Events.off null, null, @
      return

    viewWelcome: () ->
      if Playlyfe.getStatus().code is 2
        welcomeView = new WelcomeView()
        @getView('#canvas')?.remove()
        @setView '#canvas', welcomeView
        welcomeView.render()
      return

    viewLogin: () ->
      loginView = new LoginView()
      @getView('#canvas')?.remove()
      @setView '#canvas', loginView
      loginView.render()
      return

    viewTimer: (task) ->
      timerView = new TimerView( model: new Timer( {rootId: task.get('rootId'), task: task} ) )
      @getView('#canvas')?.remove()
      @setView '#canvas', timerView
      timerView.render()
      return

    logout: () ->
      Playlyfe.logout("#{window.location}/logout")
      return

    serialize: () ->
      { user: Core.PLAYER }
