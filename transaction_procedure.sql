CREATE OR REPLACE PROCEDURE realizar_transacao(
    IN p_type CHAR(1),
    IN p_description VARCHAR(10),
    IN p_value INTEGER,
    IN p_client_id UUID
)
LANGUAGE plpgsql


AS $$
DECLARE
    saldo_atual INTEGER;
    limite_cliente INTEGER;
BEGIN
	    -- Obtém o saldo atual e o limite do cliente
	SELECT balance, credit_limit INTO saldo_atual, limite_cliente
	FROM clients c 
	WHERE id = p_client_id;

	-- Verifica se a transação é válida com base no saldo e no limite
	IF p_type = 'd' AND saldo_atual - p_value < -limite_cliente THEN
	    RAISE EXCEPTION 'Saldo insuficiente para realizar a transação';
	END IF;

	-- Atualiza o saldo do cliente
	UPDATE clients
	SET balance  = balance + CASE WHEN p_type = 'd' THEN -p_value ELSE p_value END
	WHERE id = p_client_id;

	-- Insere uma nova transação
	INSERT INTO transactions (type, description , value , client_id)
	VALUES (p_type, p_description, p_value, p_client_id);

END;
$$;



CALL realizar_transacao('d', 'carro', 5000, '91509c12-d006-4cbc-ae86-9bcf15307b66');