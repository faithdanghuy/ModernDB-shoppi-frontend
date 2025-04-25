import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/features/auth/bloc/auth_bloc.dart';
import 'package:shoppi_frontend/features/auth/bloc/auth_event.dart';
import 'package:shoppi_frontend/features/auth/pages/login_screen.dart';
import 'package:shoppi_frontend/cores/extensions/extension_context.dart';
import 'package:shoppi_frontend/features/auth/model/user_model.dart';
import 'package:shoppi_frontend/features/home/pages/appbar_widget.dart';
import 'package:shoppi_frontend/features/home/pages/home_screen.dart';
import 'package:shoppi_frontend/features/profile/bloc/profile_state.dart';
import 'package:shoppi_frontend/features/profile/bloc/profile_bloc.dart';
import 'package:shoppi_frontend/features/profile/bloc/profile_event.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc profileBloc = ProfileBloc();
  final AuthBloc authBloc = AuthBloc();
  UserModel? userProfile;
  bool isLoading = true;
  String? errorMessage;
  bool isEditing = false;

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    profileBloc.add(const EventGetProfile());
  }

  @override
  void dispose() {
    profileBloc.close();
    fullnameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
      if (isEditing && userProfile != null) {
        fullnameController.text = userProfile!.fullName ?? '';
        addressController.text = userProfile!.address ?? '';
        phoneController.text = userProfile!.phone ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listener: (context, state) {
        if (state is StateGetProfile) {
          if (state.success) {
            setState(() {
              userProfile = state.userModel;
              isLoading = false;

              isEditing = false;
            });
          } else {
            setState(() {
              errorMessage = state.message ?? "Failed to load profile";
              isLoading = false;

              isEditing = false;
              authBloc.add(EventLogout());

              context.pop();
              showLoginDialog(context);
            });
          }
        } else if (state is StateUpdateProfile) {
          if (state.success) {
            setState(() {
              profileBloc.add(const EventGetProfile());
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Profile updated successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? "Failed to update profile"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: const ShoppiAppBar(),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            userProfile?.username ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            userProfile?.email ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text(
                              "Account Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              iconSize: 14,
                              icon: Icon(isEditing ? Icons.cancel : Icons.edit),
                              onPressed: toggleEditMode,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (isEditing)
                          Column(
                            children: [
                              TextField(
                                controller: fullnameController,
                                decoration: const InputDecoration(
                                  labelText: 'Full name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  profileBloc.add(EventUpdateProfile(
                                    email: userProfile?.email ?? '',
                                    fullname: fullnameController.text.trim(),
                                    address: addressController.text.trim(),
                                    phone: phoneController.text.trim(),
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5722),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "SAVE",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Full name: ${userProfile?.fullName ?? ''}"),
                              const SizedBox(height: 8),
                              Text("Address: ${userProfile?.address ?? ''}"),
                              const SizedBox(height: 8),
                              Text("Phone: ${userProfile?.phone ?? ''}"),
                            ],
                          ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            authBloc.add(EventLogout());
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Logout successful!"),
                                backgroundColor: Color(0xFFFF5722),
                              ),
                            );
                            context.goUntil(const HomeScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "LOG OUT",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
