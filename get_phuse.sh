curl -X POST -H "Content-Type: application/json" \
-d '{"query": "query{\\n      archives(sort: \\"year:DESC\\", limit: 20,  start: 0, where: { event: \\"Connect\\
"})  {\\n        event\\n        year\\n        city\\n        region\\n        title\\n        author\\n        company
\\n        co_author\\n        educational_category\\n        keywords\\n        filename    \\n      }\\n}\\n"}' \
https://phuse.global/api/graphql