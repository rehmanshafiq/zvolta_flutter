import 'package:flutter/material.dart';
import 'package:zvolta_flutter/domain/entities/recent_charge_entity.dart';
import 'package:zvolta_flutter/presentation/widgets/charge_session_card.dart';

/// Recent charge list item on the home screen.
class HomeRecentChargeCard extends StatelessWidget {
  const HomeRecentChargeCard({
    super.key,
    required this.charge,
  });

  final RecentChargeEntity charge;

  @override
  Widget build(BuildContext context) {
    return ChargeSessionCard(charge: charge);
  }
}
