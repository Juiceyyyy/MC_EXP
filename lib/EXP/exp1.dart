import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(LoanEmiCalculator());

class LoanEmiCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan EMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoanEmiCalculatorPage(),
    );
  }
}

class LoanEmiCalculatorPage extends StatefulWidget {
  @override
  _LoanEmiCalculatorPageState createState() => _LoanEmiCalculatorPageState();
}

class _LoanEmiCalculatorPageState extends State<LoanEmiCalculatorPage> {
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _loanTenureController = TextEditingController();
  String _emi = '';
  String _errorMessage = '';

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _loanTenureController.dispose();
    super.dispose();
  }

  void _calculateEmi() {
    setState(() {
      _errorMessage = ''; // Reset error message
    });

    try {
      double loanAmount = double.parse(_loanAmountController.text);
      double interestRate = double.parse(_interestRateController.text) / 100;
      int loanTenure = int.parse(_loanTenureController.text);

      double monthlyInterestRate = interestRate / 12;
      int numberOfPayments = loanTenure * 12;

      double emi = (loanAmount *
          monthlyInterestRate *
          pow((1 + monthlyInterestRate), numberOfPayments)) /
          (pow((1 + monthlyInterestRate), numberOfPayments) - 1);

      setState(() {
        _emi = emi.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Please enter valid inputs';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan EMI Calculator'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildTextField(
              controller: _loanAmountController,
              labelText: 'Loan Amount',
            ),
            _buildTextField(
              controller: _interestRateController,
              labelText: 'Interest Rate (%)',
            ),
            _buildTextField(
              controller: _loanTenureController,
              labelText: 'Loan Tenure (Years)',
            ),
            ElevatedButton(
              onPressed: _calculateEmi,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Calculate EMI'),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            Text(
              'EMI: ₹$_emi',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelText}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }
}
