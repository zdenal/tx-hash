defmodule TxChecker.Explorer.BlockCypher do
  @behaviour TxChecker.Behaviours.Explorer

  @url "https://api.blockcypher.com/v1/eth/main"

  @type error :: {:error, binary()} | {:error, {atom(), binary()}}

  require Logger

  alias TxChecker.Explorer.TxDetail

  @spec tx_detail(binary()) :: {:ok, map()} | error
  @impl Explorer
  def tx_detail(hash) do
    Logger.debug("Getting tx detail for: #{hash}.")
    url = "#{@url}/txs/#{hash}"

    with {:ok, response} <- HTTPoison.get(url),
         %HTTPoison.Response{body: body, status_code: status} = response do
      handle_response(status, body)
    else
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      e -> {:error, e}
    end
  end

  @spec handle_response(non_neg_integer(), binary()) :: {:ok, map()} | error
  defp handle_response(status, body)

  defp handle_response(status, body) when status >= 200 and status <= 304 do
    with {:ok,
          %{"hash" => hash, "confirmations" => confirmations, "block_height" => block_number}} <-
           Poison.decode(body) do
      {:ok, %TxDetail{hash: hash, confirmations: confirmations, block_number: block_number}}
    else
      {:error, error} -> {:error, {:invalid_json, error}}
      {:error, _error, 0} -> {:error, :invalid_hash}
      error -> {:error, error}
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
