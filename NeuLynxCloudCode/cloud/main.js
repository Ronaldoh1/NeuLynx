
// Use Parse.Cloud.define to define as many cloud functions as you want.


Parse.Cloud.define('updateUser', function(request, response) {
                   var userId = request.params.userId;
                   var activityId = request.params.activityId;

                   var query = new Parse.Query(Parse.User);
                   query.get(userId).then(function(user) {
                                          user.addUnique("exclusiveActivity", activityId);
                                          return user.save(null, {userMasterKey:true});
                                          }).then(function(user) {
                                                  response.success(user);
                                                  }, function(error) {
                                                  response.error(error);
                                                  });
                   });



//                   user.addUnique("exclusiveActivity", activityId)

//
//                   user.save(null, {userMasterKey:true}).then(function(user) {
//                                    response.success(user);
//                                    }, function(error) {
//                                    response.error(error)
//                                    });
//                   
//                   });