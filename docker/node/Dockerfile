FROM node:24-alpine

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

WORKDIR /app

EXPOSE 5173

ENTRYPOINT ["docker-entrypoint"]
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
