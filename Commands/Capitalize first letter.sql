SELECT
  UPPER(LEFT(<column>, 1))+ LOWER(RIGHT(<column>, LEN(<column>)-1))
FROM
  <TABLE>;
