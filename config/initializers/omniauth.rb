Rails.application.config.middleware.use OmniAuth::Builder do
    # oauth
    #'KEY', 'SECRET'にそれぞれのサービスへの登録で取得したコードを記入して下さい
    provider :facebook,       '203276849782760',        '96fe96e404af7405790b60c12db77d37'
    provider :twitter,        'nWbFbFY07TaCAK3PwURiXQ', 'PQiT2VfNLKmWLBLp32i4Fr5iVWqxXWCZpctGEa4VY'
    provider :google_oauth2,  'movie.seeen.net',        'rUmJ7i2r5xuWTOB18Stj89Xn', {access_type: 'online', approval_prompt: ''}
end
