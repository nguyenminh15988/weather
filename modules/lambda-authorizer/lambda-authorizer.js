const jwt = require('jsonwebtoken');
const jwksClient = require('jwks-rsa');

// Cognito User Pool Details
const USER_POOL_ID = 'your-user-pool-id';
const REGION = 'ap-south-1';
const CLIENT_ID = 'your-client-id';

// JWKS Client
const client = jwksClient({
  jwksUri: `https://cognito-idp.${REGION}.amazonaws.com/${USER_POOL_ID}/.well-known/jwks.json`,
});

// Helper function to get the signing key
function getKey(header, callback) {
  client.getSigningKey(header.kid, (err, key) => {
    if (err) {
      callback(err);
    } else {
      const signingKey = key.publicKey || key.rsaPublicKey;
      callback(null, signingKey);
    }
  });
}

// Lambda Authorizer
exports.handler = async (event) => {
  try {
    const token = event.authorizationToken.replace('Bearer ', '');
    const decoded = await new Promise((resolve, reject) => {
      jwt.verify(token, getKey, { algorithms: ['RS256'] }, (err, decoded) => {
        if (err) {
          reject(err);
        } else {
          resolve(decoded);
        }
      });
    });

    // Validate token audience and issuer
    if (decoded.aud !== CLIENT_ID || decoded.iss !== `https://cognito-idp.${REGION}.amazonaws.com/${USER_POOL_ID}`) {
      throw new Error('Invalid token');
    }

    // Return policy allowing access
    return {
      principalId: decoded.sub,
      policyDocument: {
        Version: '2012-10-17',
        Statement: [
          {
            Action: 'execute-api:Invoke',
            Effect: 'Allow',
            Resource: event.methodArn,
          },
        ],
      },
    };
  } catch (error) {
    console.error('Authorization failed:', error);
    return {
      principalId: 'user',
      policyDocument: {
        Version: '2012-10-17',
        Statement: [
          {
            Action: 'execute-api:Invoke',
            Effect: 'Deny',
            Resource: event.methodArn,
          },
        ],
      },
    };
  }
};