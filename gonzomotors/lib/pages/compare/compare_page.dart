import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/app_injection.dart';
import '../../features/compare/bloc/compare_bloc.dart';
import '../../features/compare/bloc/compare_event.dart';
import '../../features/compare/bloc/compare_state.dart';
import '../../features/compare/data/models/compare_result.dart';

class ComparePage extends StatelessWidget {
  final int carId1;
  final int carId2;

  const ComparePage({super.key, required this.carId1, required this.carId2});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompareBloc(repository: sl.get())
        ..add(LoadComparisonEvent(carId1: carId1, carId2: carId2)),
      child: const Scaffold(
        backgroundColor: Color(0xFFF6F7F9),
        body: SafeArea(
          child: _CompareView(),
        ),
      ),
    );
  }
}

class _CompareView extends StatelessWidget {
  const _CompareView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompareBloc, CompareState>(
      builder: (context, state) {
        if (state.status.isLoading() || state.result == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status.isError()) {
          return Center(
            child: Text(
              state.status.message ?? 'Ошибка загрузки сравнения',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final result = state.result!;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 16),
                    const Text('Сравнение', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),

              // Title Header (Names)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.car1.carName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF111827)),
                        ),
                      ),
                      Container(width: 1, height: 24, color: const Color(0xFFE5E7EB)),
                      Expanded(
                        child: Text(
                          result.car2.carName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF6B7280)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildSection(
                title: 'Производительность',
                children: [
                  _buildComparisonRow('0-100 км/ч', result.performance?.zeroTo100),
                  _buildComparisonRow('Макс. скорость', result.performance?.maxSpeed),
                  _buildComparisonRow('Мощность', result.performance?.totalPowerHp),
                  _buildComparisonRow('Привод', result.transmission?.driveType),
                ],
              ),
              _buildSection(
                title: 'Зарядка',
                children: [
                  _buildComparisonRow('АС бортовое ЗУ', result.battery?.capacityKwh), // Map from API if specific exist
                  _buildComparisonRow('DC ПИК', result.battery?.fastChargingHours), 
                  _buildComparisonRow('10 - 80%', result.battery?.slowChargingHours),
                ],
              ),
              _buildSection(
                title: 'Размеры и багажник',
                children: [
                  _buildComparisonRow('ДxШxВ', _combineSize(result.dimensions)),
                  _buildComparisonRow('Колесная база', result.dimensions?.wheelBase),
                  _buildComparisonRow('Багажник', result.volumeMass?.trunkVolumeMax),
                ],
              ),
              _buildSection(
                title: 'Интерьер и комфорт',
                children: [
                  _buildComparisonRow('Мест', result.generalInfo?.seatCount),
                  _buildComparisonRow('Динамиков', result.multimedia?.speakers),
                  _buildComparisonRowBool('Массаж/ вентиляция', result.multimedia?.hasMassage, result.multimedia?.hasVentilation),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, ComparisonValue? comparison) {
    if (comparison == null) return const SizedBox();
    
    // Check winner
    bool isLeftBetter = comparison.winner == ComparisonWinner.car1;
    bool isRightBetter = comparison.winner == ComparisonWinner.car2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildValueBox(comparison.value1?.toString() ?? '-', isLeftBetter, comparison.difference, isWinnerValue: isLeftBetter),
                const SizedBox(width: 8),
                _buildValueBox(comparison.value2?.toString() ?? '-', isRightBetter, comparison.difference, isWinnerValue: isRightBetter),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildComparisonRowBool(String label, ComparisonValue<bool>? comp1, ComparisonValue<bool>? comp2) {
      if (comp1 == null) return const SizedBox();
      // simplified mapping for demonstration
      final leftHas = comp1.value1 == true || comp2?.value1 == true;
      final rightHas = comp1.value2 == true || comp2?.value2 == true;
      
      bool isLeftBetter = leftHas && !rightHas;
      bool isRightBetter = rightHas && !leftHas;
      
      return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildValueBox(leftHas ? 'Есть' : 'Нет', isLeftBetter, null, isWinnerValue: isLeftBetter, isBool: true),
                const SizedBox(width: 8),
                _buildValueBox(rightHas ? 'Есть' : 'Нет', isRightBetter, null, isWinnerValue: isRightBetter, isBool: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueBox(String value, bool isHighlighted, String? difference, {bool isWinnerValue = false, bool isBool = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: isHighlighted ? const Color(0xFF10B981).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            if (isHighlighted && !isBool && difference != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_upward, size: 10, color: Color(0xFF10B981)),
                  Text(
                    difference.replaceAll(' ✓', '').replaceAll(' ✗', ''),
                    style: const TextStyle(fontSize: 10, color: Color(0xFF10B981)),
                  ),
                ],
              ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                color: isHighlighted ? const Color(0xFF10B981) : (isBool ? const Color(0xFF111827) : const Color(0xFF6B7280)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  ComparisonValue<String>? _combineSize(DimensionsComparison? dims) {
      if(dims == null) return null;
      final val1 = "${dims.lengthMm.value1}x${dims.widthMm.value1}x${dims.heightMm.value1}";
      final val2 = "${dims.lengthMm.value2}x${dims.widthMm.value2}x${dims.heightMm.value2}";
      return ComparisonValue<String>(value1: val1, value2: val2, isDifferent: val1 != val2, winner: dims.lengthMm.winner);
  }
}
