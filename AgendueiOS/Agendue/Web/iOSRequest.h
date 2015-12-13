//
//  iOSRequest.h
//  Agendue
//
//  Created by Alec on 8/5/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^RequestCompletionHandler)(NSString*, NSError*);
typedef void(^RequestCompletionHandlerData)(NSData *, NSError*);


@interface iOSRequest : NSObject
+(void)requestToPath: (NSString*) path onCompletion:(RequestCompletionHandler)complete;

+(void) loginWithUsername: (NSString *) username andPassword: (NSString *) password onCompletion:(RequestCompletionHandler) complete;
+(void) getProjectShares: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete;

+(void) getProjectsForUserOnCompletion:(RequestCompletionHandlerData) complete;

+(void) getLandingTasksonCompletion:(RequestCompletionHandlerData) complete;

+(void) getCalendarOnCompletion:(RequestCompletionHandlerData) complete;

+(void) getLandingScoreOnCompletion:(RequestCompletionHandlerData) complete;

+(void) getLandingPersonalOnCompletion:(RequestCompletionHandlerData) complete;

+(void) getLandingIncompleteOnCompletion:(RequestCompletionHandlerData) complete;

+(void) getLoginPageonCompletion: (RequestCompletionHandler) complete;

+(void) getTasksForUserForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete;

+(void) getCompleteTasksForUserForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete;

+(void) getIncompletePersonalTasksOnCompletion: (RequestCompletionHandlerData) complete;

+(void) getCompletePersonalTasksOnCompletion: (RequestCompletionHandlerData) complete;

+(void) getIncompleteTasksForUserForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete;

+(void) getMessagesForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete;

+(void) getWikiForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete;

+(void) getEditWikiForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete;

+(void) getCanShareProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete;

+(void) getDetailsForTask: (NSString *) taskNum onCompletion: (RequestCompletionHandlerData) complete;

+(void) getAllTasksOnCompletion: (RequestCompletionHandlerData) complete;

+(void) getAllIncompleteTasksOnCompletion:(RequestCompletionHandlerData)complete;

+(void) getAllCompleteTasksOnCompletion:(RequestCompletionHandlerData)complete;

+(void) getAssignedTasksOnCompletion:(RequestCompletionHandlerData)complete;

+(void) getAssignedIncompleteTasksOnCompletion:(RequestCompletionHandlerData)complete;

+(void) getAssignedCompleteTasksOnCompletion:(RequestCompletionHandlerData)complete;

+(void) addDeviceForAPNS: (NSString *) deviceToken onCompletion:(RequestCompletionHandlerData)complete;

+(void) addProject: (NSString *) projectName onCompletion:(RequestCompletionHandlerData)complete;

+(void) addMessage: (NSString *) messageContent onCompletion:(RequestCompletionHandlerData)complete;

+(void) deleteProject: (NSString *) projectID onCompletion:(RequestCompletionHandlerData)complete;

+(void) editProject: (NSString *) projectID withName: (NSString *) name andShareWith: (NSString *) share onCompletion: (RequestCompletionHandlerData) complete;

+(void) addShare: (NSString *) share toProjectWithId: (NSString *) webID onCompletion: (RequestCompletionHandlerData) complete;

+(void) logOutonCompletion: (RequestCompletionHandlerData) complete;

+(void) addPersonalTaskName: (NSString *) name withDescription: (NSString *) description isCompleted: (bool) completed dueDate: (NSString *) dueDate label: (NSString *) label onCompletion: (RequestCompletionHandlerData) complete;

+(void) addTaskName: (NSString *) name withDescription: (NSString *) description assignedTo: (NSString *) assign isCompleted: (bool) completed dueDate: (NSString *) dueDate personalDueDate: (NSString *) personalDueDate label: (NSString *) label toProject: (NSString *) webID onCompletion: (RequestCompletionHandlerData) complete;

+(void) saveEditedTask: (NSString *) webID withName: (NSString *) name description: (NSString *) description assignment: (NSString *) assign completed: (NSString *) completed duedate: (NSString *) duedate personalDueDate: (NSString *) personalduedate label: (NSString *) label onCompletion:(RequestCompletionHandlerData) complete;

+(void) saveEditedPersonalTask: (NSString *) webID withName: (NSString *) name description: (NSString *) description completed: (NSString *) completed duedate: (NSString *) duedate label: (NSString *) label onCompletion:(RequestCompletionHandlerData) complete;

+(void) completeOrIncompleteTask: (NSString *) webID completed: (NSString *) completed onCompletion:(RequestCompletionHandlerData) complete;

+(void) deleteTask: (NSString *) taskID onCompletion:(RequestCompletionHandlerData)complete;

+(void) deletePersonalTask: (NSString *) taskID onCompletion:(RequestCompletionHandlerData)complete;

+(void) getUserPageOnCopmletion: (RequestCompletionHandlerData) complete;

+(void) createAccountEmail: (NSString *) email firstName: (NSString *) firstName lastName: (NSString *) lastName password: (NSString *) password passwordConfirm: (NSString *) passwordConfirm onCompletion:(RequestCompletionHandlerData) complete;
@end
