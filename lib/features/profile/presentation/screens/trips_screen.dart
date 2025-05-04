import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travloc/features/trips/domain/entities/trip.dart';
import 'package:travloc/features/trips/presentation/providers/trips_provider.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsyncValue = ref.watch(tripsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      body: tripsAsyncValue.when(
        data: (trips) {
          if (trips.isEmpty) {
            return const Center(
              child: Text('No trips yet. Start planning your next adventure!'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return _TripCard(trip: trip);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-trip');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;

  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Image
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(
                alpha: 200,
                red: 200,
                green: 200,
                blue: 200,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child:
                trip.imageUrl != null
                    ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Image.network(
                        trip.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                    : const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
          ),
          // Trip Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey.withValues(
                        alpha: 200,
                        red: 100,
                        green: 100,
                        blue: 100,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trip.destination,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey.withValues(
                        alpha: 200,
                        red: 100,
                        green: 100,
                        blue: 100,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${trip.startDate} - ${trip.endDate}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${trip.companions?.length ?? 0} travelers',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      trip.status.name.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(trip.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.planned:
        return Colors.orange;
      case TripStatus.ongoing:
        return Colors.green;
      case TripStatus.completed:
        return Colors.grey;
      case TripStatus.cancelled:
        return Colors.red;
    }
  }
}
