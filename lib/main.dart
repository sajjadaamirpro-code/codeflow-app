import 'package:flutter/material.dart';


enum ProjectStatus {
  planning,
  active,
  completed,
}

class Project {
  String name;
  String description;
  String technology;
  ProjectStatus status;

  Project({
    required this.name,
    required this.description,
    required this.technology,
    required this.status,
  });
  String get statusLabel {
    switch (status) {
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
    ),
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController technologyController = TextEditingController();

  ProjectStatus selectedStatus = ProjectStatus.active;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('CodeFlow'),
        ),
          body: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];

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
                          projects.removeAt(index);
                        });
                      } else if (result is Project) {
                        setState(() {
                          projects[index] = result;
                        });
                      }
                    },
                ),
              );
            },
          ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add Project'),
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
                    actions: [
                      TextButton(
                        onPressed: () {
                          final name = nameController.text.trim();
                          final description = descriptionController.text.trim();
                          final technology = technologyController.text.trim();

                          if (name.isEmpty ||
                              description.isEmpty ||
                              technology.isEmpty) {
                            return;
                          }

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
            const SizedBox(height: 24),

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