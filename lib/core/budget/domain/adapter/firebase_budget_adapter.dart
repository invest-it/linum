import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/core/budget/domain/adapter/budget_adapter.dart';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:logger/logger.dart';

class FirebaseBudgetAdapter extends IBudgetAdapter {
  final String _userId;

  FirebaseBudgetAdapter(this._userId);

  DocumentReference get _userDocument => FirebaseFirestore.instance.collection('users').doc(_userId);
  CollectionReference get _budgetCollection => _userDocument.collection('budgets');
  CollectionReference get _mainBudgetCollection => _userDocument.collection('main_budgets');

  @override
  Future<void> createBudget(Budget budget) async {
    final budgetDocRef = _budgetCollection.doc(budget.id);
    final budgetSnapshot = await budgetDocRef.get();
    if(budgetSnapshot.exists){
      Logger().i("budget already exists");
      return;
    }
    final Map<String, dynamic> budgetMap = budget.toMap();
    budgetMap.remove("id");
    return await budgetDocRef.set(budgetMap);
  }

  @override
  Future<void> createMainBudget(MainBudget mainBudget) async {
    final mainBudgetDocRef = _mainBudgetCollection.doc(mainBudget.id);
    final mainBudgetSnapshot = await mainBudgetDocRef.get();
    if(mainBudgetSnapshot.exists){
      Logger().i("MainBudget already exists");
      return;
    }
    final Map<String, dynamic> budgetMap = mainBudget.toMap();
    budgetMap.remove("id");
    return await mainBudgetDocRef.set(budgetMap);
  }

  @override
  Future<void> deleteBudget(String id) async {
    final budgetDocRef = _budgetCollection.doc(id);
    final budgetSnapshot = await budgetDocRef.get();
    if(!budgetSnapshot.exists){
      Logger().i("MainBudget does not exist");
      return;
    }
    return await budgetDocRef.delete();
  }

  @override
  Future<void> deleteMainBudget(String id) async {
    final mainBudgetDocRef = _mainBudgetCollection.doc(id);
    final mainBudgetSnapshot = await mainBudgetDocRef.get();
    if(!mainBudgetSnapshot.exists){
      Logger().i("MainBudget does not exist");
      return;
    }
    return await mainBudgetDocRef.delete();
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    final budgetDocRef = _budgetCollection.doc(budget.id);
    final budgetSnapshot = await budgetDocRef.get();
    if(!budgetSnapshot.exists){
      Logger().i("budget does not exist");
      return;
    }
    final Map<String, dynamic> budgetMap = budget.toMap();
    budgetMap.remove("id");
    return await budgetDocRef.set(budgetMap);
  }

  @override
  Future<void> updateMainBudget(MainBudget mainBudget) async {
    final mainBudgetDocRef = _mainBudgetCollection.doc(mainBudget.id);
    final mainBudgetSnapshot = await mainBudgetDocRef.get();
    if(!mainBudgetSnapshot.exists){
      Logger().i("MainBudget does not exist");
      return;
    }
    final Map<String, dynamic> budgetMap = mainBudget.toMap();
    budgetMap.remove("id");
    return await mainBudgetDocRef.set(budgetMap);
  }
}
