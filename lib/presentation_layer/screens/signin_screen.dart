import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_for_everybody/presentation_layer/screens/folder_grid_screen.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_event.dart';
import '../bloc/auth_bloc/auth_state.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In with BLoC'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate to HomePage when authenticated
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FolderGridScreen()),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthInitial || state is Unauthenticated) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(GoogleSignInRequested());
                },
                child: const Text('Sign in with Google'),
              ),
            );
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Welcome!'));
          }
        },
      ),
    );
  }
}
