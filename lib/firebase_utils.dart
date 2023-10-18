import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/model/my_user.dart';

import 'model/task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.fromFireStore(snapshot.data()!),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    var taskCollection = getTasksCollection(uId); // create collection
    var docRef =
        taskCollection.doc(); // create document or get document if available
    task.id = docRef.id; // auto id
    return docRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).delete();
  }

  static Future<void> editIsDone(Task task, String uId) {
    return getTasksCollection(uId)
        .doc(task.id)
        .update({'isDone': !task.isDone!});
  }

  static Future<void> editTask(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).update(task.toFireStore());
  }

  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
            fromFirestore: (snapshot, options) =>
                MyUser.fromFireStore(snapshot.data()!),
            toFirestore: (user, options) => user.toFireStore());
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var querySnapshot = await getUsersCollection().doc(uId).get();
    return querySnapshot.data();
  }

// static Future<void> editTaskToFireStore(Task task) async {
//   var edittaskCollection = getTasksCollection(); // create collection
//   var docRef = edittaskCollection.doc(task.id).update({
//     task.title as String : task.title ,
//     task.description as String: task.description,
//
//   }); // create document or get document if available
//
// }
}
