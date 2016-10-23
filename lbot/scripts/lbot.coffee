# LunchBot for Fivium Hackday 2K16
# Notes:
#   LunchBot is a fragile delicate flower, be kind and don't break it!
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  #Resturaunt listeners. Sets current choice to the most recently mentioned place
   @ref = ['honest', 'flat_iron', 'scotts', 'five_guys', 'chipotle', 'benitos', 'homeslice'];
  #TODO Rewrite listener to just be one checking for content within the array??
  #TODO Add regex to check for more edge cases/aliases
   robot.hear /[^\?]*honest/i, (res) ->
     res.send "Suggestions open for Honest burger (burger)"
     robot.brain.set 'currentChoice', 'honest'
     if robot.brain.get('honest') == null or robot.brain.get('honest') <= 1
       res.send "Current votes: 0"
       #res.send "http://www.honestburgers.co.uk"
     else
       res.send "Current votes: ", robot.brain.get('honest') * 1 - 1

   robot.hear /[^\?]*flat iron/i, (res) ->
     res.send "Suggestions open for Flat Iron"
     robot.brain.set 'currentChoice', 'flat_iron'

  #  robot.hear /x/i, (res) ->
  #   res.send "Suggestions open for Flat Iron"
  #   robot.brain.set 'currentChoice', 'flat_iron'

   robot.hear /[^\?]*homeslice/i, (res) ->
     res.send "Suggestions open for Homeslice"
     robot.brain.set 'currentChoice', 'homeslice'

   robot.hear /[^\?]*benitos/i, (res) ->
    res.send "Suggestions open for Benitos Hat"
    robot.brain.set 'currentChoice', 'benitos'

   robot.hear /[^\?]*chipotle/i, (res) ->
    res.send "Suggestions open for Chipotle"
    robot.brain.set 'currentChoice', 'chipotle'

   robot.hear /[^\?]*five guys/i, (res) ->
     res.send "Suggestions open for Five Guys"
     robot.brain.set 'currentChoice', 'five_guys'

   robot.hear /[^\?]*scotts/i, (res) ->
     res.send "Suggestions open for Scott's"
     robot.brain.set 'currentChoice', 'scotts'

   #Voting logic .... it's ugly don't look down
   #Handle downvotes
   robot.hear /\-1|(\(thumbsdown\))/i, (res) ->
      #res.send "testing +1 response"
      cc = robot.brain.get('currentChoice') or 'na'
      res.send cc
      #rest = robot.brain.get(cc) * 1 or 0
      if (robot.brain.get(cc) <= 1) or (robot.brain.get(cc) == null)
        res.send cc + " is already at 0 votes"
      else
        robot.brain.set cc,  robot.brain.get(cc) - 1
        votes = robot.brain.get(cc) - 1
        res.send "One down vote from, " + res.message.user.name + " counted. Current total: " + votes

   #Handle upvotes
   robot.hear /(\+1)|(\(thumbsup\))/i, (res) ->
     #res.send "testing +1 response"
     cc = robot.brain.get('currentChoice') or 'na'
     res.send cc
     rest = robot.brain.get(cc) * 1 or 1
     robot.brain.set cc, rest+1
     res.send "One vote added by " + res.message.user.name + ", current total: " + rest

   #Show votes - loops through a hardcoded array ..... I told you not to look
   #HOW THE FUCK DO YOU DO LOOPS?
   robot.hear /show votes/i, (res) ->
     #replace with array list for adding options
     for i of ref
       if (robot.brain.get(ref[i]) == null) or (robot.brain.get(ref[i]) == 0)
         res.send ref[i] + ": 0"
       else
         votes = robot.brain.get(ref[i]) - 1#obviously add a minus 1 here
         res.send ref[i] + ": " + votes

   #Reset votes
   robot.hear /reset all/i, (res) ->
     for i of ref
       robot.brain.set ref[i], 0
     res.send "I just reset all the votes, I hope you wanted to do that..."

   robot.hear /reset \?(.*)/i, (res) ->
     resetMe = res.match[1]
     robot.brain.set resetMe, 0
     res.send "I just reset all the votes for: " + resetMe + " ... probably"

    #Suggestions and help listeners
    robot.hear /(veggie friendly)|(\?veggie)/i, (res) ->
      robot.brain.set 'vf', ['Honest Burger', 'Scott\'s', 'Five Guys']
      veg = robot.brain.get('vf')
      res.send "The veggie Friendly Options are: "
      for i of veg
        res.send veg[i]

    robot.hear /\?burger(s)*/i, (res) ->
      res.send "(burger) For burgers try: Honest or Five Guys"

    robot.hear /\?burrito(s)*/i, (res) ->
      res.send "For burritos try: Benitos or Chipotle"

   #Take suggestions - currently suggestions can only be voted on until someone says a new resturaunt name!!
   robot.hear /\?suggest(ion)* (.*)/i, (res) ->
     newPlace = res.match[2]
     robot.brain.set 'currentChoice', newPlace
     res.send res.message.user.name + " has suggested " + newPlace + ". Votes are now open"
     ref.push newPlace
     robot.brain.set newPlace, 0

   #Nonsense fun stuff
   robot.hear /are you my friend/i, (res) ->
     res.send "Yes, " + res.message.user.name + " your only friend. (heart)"

   robot.hear /\?pizza/i, (res) ->
     res.send "For Pizza try: Homeslice"

   enterReplies = ['Ahoy-hoy', 'LunchBot is here', 'Cast your votes!']
   robot.enter (res) ->
     res.send res.random enterReplies
