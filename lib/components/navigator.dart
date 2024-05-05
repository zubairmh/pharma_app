import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return selectedIndex != 3
        ? Container(
            margin: const EdgeInsets.fromLTRB(50, 0, 50, 25),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                color: const Color.fromARGB(255, 50, 49, 53),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      onPressed: () => onItemTapped(0),
                      icon:
                          const Icon(Icons.local_pharmacy, color: Colors.white),
                      backgroundColor: selectedIndex == 0
                          ? const Color.fromARGB(255, 102, 160, 163)
                          : Colors.transparent,
                      isSelected: selectedIndex == 0,
                    ),
                    CustomButton(
                      onPressed: () => onItemTapped(1),
                      icon: const Icon(Icons.search, color: Colors.white),
                      backgroundColor: selectedIndex == 1
                          ? const Color.fromARGB(255, 102, 160, 163)
                          : Colors.transparent,
                      isSelected: selectedIndex == 1,
                    ),
                    CustomButton(
                      onPressed: () => onItemTapped(2),
                      icon:
                          const Icon(Icons.shopping_cart, color: Colors.white),
                      backgroundColor: selectedIndex == 2
                          ? const Color.fromARGB(255, 102, 160, 163)
                          : Colors.transparent,
                      isSelected: selectedIndex == 2,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final Color backgroundColor;
  final bool isSelected;

  const CustomButton({
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        backgroundColor: backgroundColor,
        foregroundColor: isSelected ? Colors.red : Colors.white,
      ),
      child: icon,
    );
  }
}
