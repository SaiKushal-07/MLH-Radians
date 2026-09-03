// lib/features/notepad/data/repositories/note_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/note.dart';
import '../models/note_model.dart';

class NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _notesCollection(String uid, String projectId) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('projects')
        .doc(projectId)
        .collection('notes');
  }

  Stream<List<Note>> watchNotes(String uid, String projectId) {
    return _notesCollection(uid, projectId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => NoteModel.fromMap(d.id, d.data())).toList());
  }

  Future<void> addNote(String uid, String projectId, String title, String content) async {
    final now = DateTime.now();
    final model = NoteModel(id: '', title: title, content: content, createdAt: now, updatedAt: now);
    await _notesCollection(uid, projectId).add(model.toMap());
  }

  Future<void> updateNote(String uid, String projectId, Note note) async {
    final model = NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: DateTime.now(),
    );
    await _notesCollection(uid, projectId).doc(note.id).update(model.toMap());
  }

  Future<void> deleteNote(String uid, String projectId, String noteId) async {
    await _notesCollection(uid, projectId).doc(noteId).delete();
  }
}