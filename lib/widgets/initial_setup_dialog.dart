import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scout_state_provider.dart';
import '../theme/app_theme.dart';
import '../models/match_record.dart';

class InitialSetupDialog extends StatefulWidget {
  const InitialSetupDialog({super.key});

  @override
  State<InitialSetupDialog> createState() => _InitialSetupDialogState();
}

class _InitialSetupDialogState extends State<InitialSetupDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _teamNoController = TextEditingController();
  final _matchNumberController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // 下拉菜单选择的值
  TournamentLevel? _selectedTournamentLevel;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _teamNoController.dispose();
    _matchNumberController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppStateProvider>(context, listen: false);

      // 更新MatchRecord的基本信息
      provider.updateMatchInfo(
        eventCode: 'SYOF',
        tournamentLevel: _selectedTournamentLevel!,
        matchNumber: int.parse(_matchNumberController.text),
        teamNo: int.parse(_teamNoController.text),
      );

      // 关闭对话框
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 防止用户通过返回键关闭对话框
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.surfacePrimary,
                        AppTheme.surfaceSecondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppTheme.borderColor,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 顶部图标和标题
                        _buildHeader(),
                        const SizedBox(height: 20),

                        // 表单字段
                        _buildFormFields(),
                        const SizedBox(height: 20),

                        // 提交按钮
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // 标题
        Text(
          'Match Setup',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 6),

        // 副标题
        Text(
          '请设置比赛相关信息',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // 锦标赛级别下拉菜单
        _buildTournamentLevelDropdown(),
        const SizedBox(height: 12),

        // 比赛编号输入框
        _buildTextFormField(
          controller: _matchNumberController,
          label: 'Match Number / 比赛编号',
          hint: '输入比赛编号',
          icon: Icons.numbers,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入比赛编号';
            }
            final number = int.tryParse(value);
            if (number == null || number <= 0) {
              return '请输入有效的比赛编号';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),

        // 队伍编号输入框
        _buildTextFormField(
          controller: _teamNoController,
          label: 'Team Number / 队伍编号',
          hint: '输入队伍编号',
          icon: Icons.groups,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入队伍编号';
            }
            final number = int.tryParse(value);
            if (number == null || number <= 0) {
              return '请输入有效的队伍编号';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTournamentLevelDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<TournamentLevel>(
        value: _selectedTournamentLevel,
        style: TextStyle(color: AppTheme.textPrimary, fontSize: 16),
        dropdownColor: AppTheme.surfacePrimary,
        decoration: InputDecoration(
          labelText: 'Tournament Level / 锦标赛级别',
          hintText: '请选择锦标赛级别',
          prefixIcon: Icon(Icons.emoji_events, color: AppTheme.primaryColor),
          labelStyle: TextStyle(color: AppTheme.textSecondary),
          hintStyle: TextStyle(color: AppTheme.textDisabled),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: TournamentLevel.values.map((TournamentLevel level) {
          return DropdownMenuItem<TournamentLevel>(
            value: level,
            child: Text(
              level.value,
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          );
        }).toList(),
        onChanged: (TournamentLevel? newValue) {
          setState(() {
            _selectedTournamentLevel = newValue;
          });
        },
        validator: (value) {
          if (value == null) {
            return '请选择锦标赛级别';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        style: TextStyle(color: AppTheme.textPrimary, fontSize: 16),
        dropdownColor: AppTheme.surfacePrimary,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          labelStyle: TextStyle(color: AppTheme.textSecondary),
          hintStyle: TextStyle(color: AppTheme.textDisabled),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: AppTheme.textPrimary, fontSize: 16),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          labelStyle: TextStyle(color: AppTheme.textSecondary),
          hintStyle: TextStyle(color: AppTheme.textDisabled),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _submitForm,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Start Match / 开始比赛',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
