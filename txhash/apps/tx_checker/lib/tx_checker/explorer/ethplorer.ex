##################################################################
## !!!!! PLEASE DO NOT USE THIS EXPLORER AS IT ISN'T FINISHED
## !!!!! PROPERLY TO HANDLE CORECTLY RESPONSES AND HAVE VARS
## !!!!!  IN CONFIG FILE
##################################################################
defmodule TxChecker.Explorer.Ethplorer do
  @behaviour TxChecker.Behaviours.Explorer

  @type error :: {:error, binary()} | {:error, {atom(), binary()}}

  require Logger

  alias TxChecker.Explorer.TxDetail

  @spec tx_detail(binary()) :: {:ok, map()} | error
  @impl Explorer
  def tx_detail(hash) do
    Logger.debug("Getting ethplorer tx detail for: #{hash}.")

    with {:ok, response} <- HTTPoison.get(tx_url(hash)),
         %HTTPoison.Response{body: body, status_code: status} = response do
      handle_response(status, body)
    else
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      e -> {:error, e}
    end
  end

  defp tx_url(tx_hash) do
    "http://api.ethplorer.io/getTxInfo/" <> tx_hash <> "?apiKey=freekey"
  end

  @spec handle_response(non_neg_integer(), binary()) :: {:ok, map()} | error
  defp handle_response(status, body)

  defp handle_response(status, body) when status >= 200 and status <= 304 do
    with {:ok, %{"hash" => hash, "confirmations" => confirmations, "blockNumber" => block_number}} <-
           Poison.decode(body) do
      {:ok, %TxDetail{hash: hash, confirmations: confirmations, block_number: block_number}}
    else
      {:error, error} -> {:error, {:invalid_json, error}}
    end
  end

  defp handle_response(_status, body) do
    with {:ok, decoded_body} <- Poison.decode(body) do
      {:error, {:api_error, decoded_body["error"]}}
    else
      {:error, error} -> {:error, {:invalid_json, error}}
    end
  end
end
