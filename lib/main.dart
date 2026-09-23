import 'package:flutter/material.dart';


enum ProjectStatus {
  planning,
  active,
  completed,
}


class Task {
  String title;
  bool isCompleted;

  Task({
    required this.title,
    this.isCompleted = false,
  });
}


class Project {
  String name;
  String description;
  String technology;

  ProjectStatus _status;
  String? githubUrl;
  List<Task> tasks;
  Project({
    required this.name,
    required this.description,
    required this.technology,

    required ProjectStatus status,
    this.githubUrl,
    List<Task>? tasks,
  }): _status = status, tasks = tasks ?? [];

  ProjectStatus get status => _status;

  String get statusLabel {
    switch (_status) {
      case ProjectStatus.active:
        return 'Active';

      case ProjectStatus.planning:
        return 'Planning';

      case ProjectStatus.completed:
        return 'Completed';
    }
  }
}


void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CodeFlow',
      home: CodeFlowApp(),
    ),
  );
}

class CodeFlowApp extends StatefulWidget {

  const CodeFlowApp({super.key});

  @override
  State<CodeFlowApp> createState() => _CodeFlowAppState();
}

class _CodeFlowAppState extends State<CodeFlowApp> {

  List<Project> projects = [
    Project(
      name: 'CodeFlow',
      description: 'Developer project management application',
      technology: 'Flutter',
      status: ProjectStatus.active,
      githubUrl: 'https://github.com/...',
      tasks: [
        Task(title: 'Add search'),
        Task(title: 'Add filters'),
      ],
    ),
    Project(
      name: 'Weather App',
      description: 'Weather application using REST API',
      technology: 'Flutter',
      status: ProjectStatus.completed,
    ),
    Project(
      name: 'E-Commerce App',
      description: 'Shopping application with Firebase',
      technology: 'Flutter',
      status: ProjectStatus.planning,
      githubUrl: 'https://github.com/...',
    ),
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController technologyController = TextEditingController();
  final GlobalKey<FormState> addProjectFormKey =
  GlobalKey<FormState>();
  final TextEditingController searchController =
  TextEditingController();
  String searchQuery = '';
  String selectedFilter = 'All';


  ProjectStatus selectedStatus = ProjectStatus.active;

  @override
  Widget build(BuildContext context) {
    final filteredProjects = projects.where((project) {
      final matchesSearch = project.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesStatus =
          selectedFilter == 'All' ||
              project.statusLabel == selectedFilter;

      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CodeFlow'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search projects',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedFilter,
              decoration: const InputDecoration(
                labelText: 'Filter by status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('All'),
                ),
                DropdownMenuItem(
                  value: 'Active',
                  child: Text('Active'),
                ),
                DropdownMenuItem(
                  value: 'Planning',
                  child: Text('Planning'),
                ),
                DropdownMenuItem(
                  value: 'Completed',
                  child: Text('Completed'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  final project = filteredProjects[index];

                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Text(project.name),
                      subtitle: Text(
                        '${project.technology} ••••• ${project.statusLabel}',
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProjectDetailsScreen(project: project),
                          ),
                        );

                        if (result == 'delete') {
                          setState(() {
                            projects.remove(project);
                          });
                        } else if (result is Project) {
                          setState(() {
                            final originalIndex =
                            projects.indexOf(project);

                            projects[originalIndex] = result;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ], // closes children: [
        ), // closes Column
      ), // closes Padding

      floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add Project'),
                      content: Form(
                        key: addProjectFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Project Name',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Project name is required';
                                }

                                if (value.trim().length < 3) {
                                  return 'Name must contain at least 3 characters';
                                }

                                return null;
                              },
                            ),

                            TextFormField(
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Description is required';
                                }

                                if (value.trim().length < 10) {
                                  return 'Description must contain at least 10 characters';
                                }

                                return null;
                              },
                            ),

                            TextFormField(
                              controller: technologyController,
                              decoration: const InputDecoration(
                                labelText: 'Technology',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Technology is required';
                                }

                                return null;
                              },
                            ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField<ProjectStatus>(
                          value: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: ProjectStatus.active,
                              child: Text('Active'),
                            ),
                            DropdownMenuItem(
                              value: ProjectStatus.planning,
                              child: Text('Planning'),
                            ),
                            DropdownMenuItem(
                              value: ProjectStatus.completed,
                              child: Text('Completed'),
                            ),
                          ],
                          onChanged: (value) {
                            selectedStatus = value!;
                          },
                        ),
                      ],
                    ),
                      ),
                    actions: [
                      TextButton(
                        onPressed: () {

                          if (!addProjectFormKey.currentState!.validate()) {
                            return;
                          }
                          final name = nameController.text.trim();
                          final description = descriptionController.text.trim();
                          final technology = technologyController.text.trim();



                          setState(() {
                            projects.add(
                              Project(
                                name: name,
                                description: description,
                                technology: technology,
                                status: selectedStatus,
                              ),
                            );
                          });

                          nameController.clear();
                          descriptionController.clear();
                          technologyController.clear();

                          Navigator.pop(context);
                        },
                        child: const Text('Save Project'),
                      ),
                    ],
                  );
                },
              );
            },
          child: const Icon(Icons.add),
        ),

    );
  }


}
class ProjectDetailsScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${project.description}'),
            const SizedBox(height: 12),
            Text('Technology: ${project.technology}'),
            const SizedBox(height: 12),
            Text('Status: ${project.status.name}'),
            const SizedBox(height: 12),
            Text(project.githubUrl ?? 'No GitHub repository'),
            const SizedBox(height: 24),



            Text(
              'Tasks: ${project.tasks.length}',
            ),            const SizedBox(height: 12),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                final nameController =
                TextEditingController(text: project.name);

                final descriptionController =
                TextEditingController(text: project.description);

                final technologyController =
                TextEditingController(text: project.technology);

                ProjectStatus status = project.status;

                final updatedProject = await showDialog<Project>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Edit Project'),

                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Project Name',
                            ),
                          ),

                          TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                          ),

                          TextField(
                            controller: technologyController,
                            decoration: const InputDecoration(
                              labelText: 'Technology',
                            ),
                          ),

                          DropdownButtonFormField<ProjectStatus>(
                            value: status,
                            items: const [
                              DropdownMenuItem(
                                value: ProjectStatus.active,
                                child: Text('Active'),
                              ),
                              DropdownMenuItem(
                                value: ProjectStatus.planning,
                                child: Text('Planning'),
                              ),
                              DropdownMenuItem(
                                value: ProjectStatus.completed,
                                child: Text('Completed'),
                              ),
                            ],
                            onChanged: (value) {
                              status = value!;
                            },
                          ),
                        ],
                      ),

                      actions: [
                        TextButton(
                          onPressed: () {
                            final updated = Project(
                              name: nameController.text.trim(),
                              description:
                              descriptionController.text.trim(),
                              technology:
                              technologyController.text.trim(),
                              status: status,
                            );

                            Navigator.pop(dialogContext, updated);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );

                if (updatedProject != null) {
                  Navigator.pop(context, updatedProject);
                }
              },
              child: const Text('Edit Project'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'delete');
              },
              child: const Text('Delete Project'),
            ),
          ],
        ),
      ),
    );
  }
}