import 'package:flutter/material.dart';

// Page de liste des véhicules par catégorie
class CategoryListPage extends StatelessWidget {
  final String categoryName;

  const CategoryListPage({Key? key, required this.categoryName}) : super(key: key);

  // Exemple de données pour chaque catégorie
  List<String> _getVehicleList(String category) {
    switch (category) {
      case 'Luxury':
        return ['Rolls Royce', 'Bentley', 'Maserati'];
      case 'Sport':
        return ['Ferrari', 'Lamborghini', 'Porsche'];
      case 'SUV':
        return ['Range Rover', 'BMW X5', 'Audi Q7'];
      case 'Convertible':
        return ['BMW Z4', 'Mercedes-Benz SL', 'Audi A5'];
      case 'Business':
        return ['Mercedes-Benz S-Class', 'BMW 7 Series', 'Audi A8'];
      case 'Electric (EV)':
        return ['Tesla Model S', 'BMW i4', 'Audi e-tron'];
      case 'VAN':
        return ['Mercedes-Benz V-Class', 'Ford Transit', 'Toyota Sienna'];
      case 'Economy':
        return ['Toyota Corolla', 'Honda Civic', 'Ford Fiesta'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer la liste des véhicules en fonction de la catégorie
    List<String> vehicleList = _getVehicleList(categoryName);

    return Scaffold(
      appBar: AppBar(
        title: Text('Véhicules - $categoryName'),
      ),
      body: vehicleList.isEmpty
          ? Center(child: Text("Aucun véhicule trouvé dans cette catégorie."))
          : ListView.builder(
              itemCount: vehicleList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(vehicleList[index]),
                  onTap: () {
                    // Afficher les détails du véhicule
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(vehicleList[index]),
                        content: Text('Détails du véhicule $categoryName: ${vehicleList[index]}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}