# execute with: iex -S mix run script_test.exs

TxChecker.confirm_tx("0x0c5f067be73b1e800cde86f133ff6f6c3cb4304a163d106c0f36cb267abca05c", :ethereum)
TxChecker.confirm_tx("0x4a96e9e5b7da4e53ac796e6e87f713abb42c82235131a71bd0a2c97f409e253e", :ethereum)
TxChecker.confirm_tx("0x8f26e21da90f20736136e038fafc78bcaecdeb240f22f30ae963b2a8344da7dc", :ethereum)
TxChecker.confirm_tx("0x5e8923b78440033735888778e45c46372cc4933371d8445ba687793aa8ac6e74", :ethereum)
TxChecker.confirm_tx("non_existing_hash", :ethereum)
TxChecker.confirm_tx("https://etherscan.io/tx/0x00ec1f4259fd4af3eba066fc0d8ec5f88200d0e1053837d6a8d43d73aae4ff29", :ethereum)
