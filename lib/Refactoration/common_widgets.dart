import 'package:flutter/material.dart';
import '../teacher_app/settings/SettingsScreen.dart';
import 'Colors.dart';

class CreateDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;

  const CreateDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      hint: Text(
        hint,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.hintTextColor,
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final bool showBackButton;
  final Color titleColor;
  final Color iconColor;
  final Color backgroundColor;
  final double elevation;
  final VoidCallback? onBackPressed;
  final bool showSearchIcon;
  final VoidCallback? onSearchPressed;
  final Widget? searchField;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leadingIcon,
    this.showBackButton = false,
    this.titleColor = AppColors.white,
    this.iconColor = AppColors.white,
    this.backgroundColor = AppColors.appBarColor,
    this.elevation = 0,
    this.onBackPressed,
    this.showSearchIcon = false,
    this.onSearchPressed,
    this.searchField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: searchField ??
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
      centerTitle: true,
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: iconColor,
                size: 30,
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : leadingIcon != null
              ? Icon(
                  leadingIcon,
                  color: iconColor,
                  size: 30,
                )
              : null,
      actions: [
        if (showSearchIcon)
          IconButton(
            icon: Icon(
              Icons.search,
              color: iconColor,
              size: 30,
            ),
            onPressed: onSearchPressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TopicTextFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String nameLabel;
  final String descriptionLabel;

  const TopicTextFields({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    required this.nameLabel,
    required this.descriptionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: nameLabel),
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(labelText: descriptionLabel),
        ),
      ],
    );
  }
}

class FilePickerButton extends StatelessWidget {
  final String? filePath;
  final VoidCallback onPickFile;
  final String uploadText;
  final Color buttonColor;
  final Color iconColor;
  final Color textColor;

  const FilePickerButton({
    Key? key,
    required this.filePath,
    required this.onPickFile,
    required this.uploadText,
    this.buttonColor = AppColors.primaryColor,
    this.iconColor = AppColors.primaryColor,
    this.textColor = AppColors.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      onPressed: onPickFile,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.attach_file, color: iconColor),
          const SizedBox(width: 8),
          Text(
            filePath != null ? filePath!.split('/').last : uploadText,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }
}

class ManageDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) itemToString;
  final void Function(T?) onChanged;
  final double? width;
  final bool isExpanded;

  const ManageDropdown({
    required this.value,
    required this.items,
    required this.itemToString,
    required this.onChanged,
    this.width,
    this.isExpanded = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButton<T>(
        value: value,
        isExpanded: isExpanded,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(itemToString(item)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = AppColors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class GenericCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final BorderRadius borderRadius;

  const GenericCard({
    required this.child,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: child,
    );
  }
}

class ExpandableSection extends StatelessWidget {
  final bool isExpanded;
  final Widget collapsedContent;
  final Widget expandedContent;
  final VoidCallback onToggle;

  const ExpandableSection({
    required this.isExpanded,
    required this.collapsedContent,
    required this.expandedContent,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: IconButton(
            onPressed: onToggle,
            icon: Icon(
              isExpanded ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: collapsedContent,
          secondChild: expandedContent,
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

class OptionsDialog extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const OptionsDialog({
    required this.title,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ),
      actions: actions,
    );
  }
}

class TimetableCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String subject;
  final String className;

  const TimetableCard({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  startTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 50,
                  width: 2,
                  color: AppColors.hintTextColor,
                ),
                const SizedBox(height: 5),
                Text(
                  endTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.hintTextColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Subject:",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textColor_2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Class:",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textColor_2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      className,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Widget destination;

  const DashboardButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            color: color,
            child: SizedBox(
              height: 100,
              width: 110,
              child: Center(
                child: Icon(
                  icon,
                  size: 55,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogoutTap;

  const CustomDrawer({super.key, required this.onLogoutTap});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> drawerItems = [
      {
        'icon': Icons.settings,
        'title': 'Settings',
        'onTap': () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SettingsScreen()));
        },
      },
      {
        'icon': Icons.logout,
        'title': 'Logout',
        'onTap': () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
          if (shouldLogout == true) {
            onLogoutTap();
            Navigator.pop(context);
          }
        },
      },
    ];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(
        Scaffold.of(context).hasDrawer ? 0 : MediaQuery.of(context).size.width,
        0,
        0,
      ),
      child: Drawer(
        elevation: 16,
        backgroundColor: AppColors.dialogBackground,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 160,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.dialogBackground,
                      AppColors.appBarColor,
                      AppColors.primaryColor,
                      AppColors.appBarColor,
                      AppColors.formTextColor,
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            ...drawerItems.map((item) => ListTile(
                  leading: Icon(item['icon']),
                  title: Text(item['title']),
                  onTap: item['onTap'],
                )),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        child: Icon(icon, color: AppColors.white),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

Widget buildDetailField(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.textColor_2,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.hintTextColor, width: 1),
          borderRadius: BorderRadius.circular(15),
          color: AppColors.dialogBackground,
        ),
        child: TextField(
          enabled: false, // Read-only
          controller: TextEditingController(text: value),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: InputBorder.none,
          ),
        ),
      ),
    ],
  );
}