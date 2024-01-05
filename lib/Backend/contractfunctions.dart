import 'package:certy_chain_nrb/Backend/abi.dart';

import 'package:web3dart/web3dart.dart';

// Function to load the deployed contract
Future<DeployedContract> loadContract(Web3Client client) async {
  // Load ABI from the asset file
  String abi = Contract_abi;
  String contractAddress = "0x48b491E2f02e40973604d22Da3cFD628d593C9d1";

  // Create a DeployedContract instance
  final contract = DeployedContract(
      ContractAbi.fromJson(abi, 'CertificateContract'),
      EthereumAddress.fromHex(contractAddress));

  return contract;
}

// Function to issue a certificate
Future<String> issueCertificateFunction(
    Web3Client client,
    String name,
    String issuer,
    String recipient,
    String purpose,
    int passOutDate,
    String signature,
    String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract(client);
  final ethFunction = contract.function('issueCertificate');

  // Convert string parameters to Ethereum compatible types
  final encodedName = EthereumAddress.fromHex(name);
  final encodedIssuer = EthereumAddress.fromHex(issuer);
  final encodedRecipient = EthereumAddress.fromHex(recipient);
  final encodedPurpose = EthereumAddress.fromHex(purpose);
  final encodedSignature = EthereumAddress.fromHex(signature);

  // Send a hash to the Ethereum blockchain
  final result = await client.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: ethFunction,
      parameters: [
        encodedName,
        encodedIssuer,
        encodedRecipient,
        encodedPurpose,
        BigInt.from(passOutDate),
        encodedSignature,
      ],
    ),
    chainId: 11155111, // Mainnet
  );

  // Return the transaction hash
  return result;
}

// Function to verify a certificate
Future<List<String>> verifyCertificateFunction(
    Web3Client client, String hashCode) async {
  DeployedContract contract = await loadContract(client);
  final ethFunction = contract.function('verifyCertificate');

  // Call the verifyCertificate function on the contract
  final result = await client.call(
    contract: contract,
    function: ethFunction,
    params: [EthereumAddress.fromHex(hashCode)],
  );

  // Convert the result to a list of strings
  List<String> certificateDetails =
      result.map((value) => value.toString()).toList();

  return certificateDetails;
}
