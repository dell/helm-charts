{{- if and (not .Values.redisPassword) (not .Values.redis.redisPassword) }}
{{ fail "Redis credentials are required. Set redis.redisPassword and redis.redisUsername." }}
{{- end }}
