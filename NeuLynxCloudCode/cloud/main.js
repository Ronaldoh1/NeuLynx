
// Use Parse.Cloud.define to define as many cloud functions as you want.

Parse.Cloud.define('updateUser', function(request, response) {

                   var userId = request.params.userId,
                   activity = request.params.activity;

                   var User = Parse.Object.extend('_User'),
                   user = new User({ objectId: userId });

                   user.addUnique("exclusiveActivity", activity)


                   Parse.Cloud.useMasterKey();
                   user.save().then(function(user) {
                                    response.success(user);
                                    }, function(error) {
                                    response.error(error)
                                    });
                   
                   });