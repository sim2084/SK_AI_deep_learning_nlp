@echo off
chcp 65001 > nul
setlocal

echo [1/9] 기존 환경 삭제...
call conda deactivate
call conda remove -n dl_nlp_env --all -y

echo [2/9] 새 환경 생성...
call conda create -n dl_nlp_env python=3.12 -y
if errorlevel 1 goto :error

echo [3/9] pip / setuptools / wheel 업그레이드...
call conda run -n dl_nlp_env python -m pip install --upgrade pip setuptools wheel
if errorlevel 1 goto :error

echo [4/9] Jupyter / 기본 데이터 처리 패키지 설치...
call conda run -n dl_nlp_env pip install notebook jupyterlab ipykernel ipywidgets
if errorlevel 1 goto :error
call conda run -n dl_nlp_env pip install numpy pandas matplotlib seaborn wordcloud
if errorlevel 1 goto :error

echo [5/9] NLP 패키지 설치...
call conda run -n dl_nlp_env pip install nltk spacy kss transformers
if errorlevel 1 goto :error

echo [6/9] 한국어 형태소 분석 패키지 설치...
call conda run -n dl_nlp_env pip install JPype1 konlpy
if errorlevel 1 goto :error

echo [7/9] 딥러닝 패키지 설치...
call conda run -n dl_nlp_env pip install tensorflow
if errorlevel 1 goto :error
call conda run -n dl_nlp_env pip install torch torchvision torchaudio
if errorlevel 1 goto :error

echo [8/9] spaCy / NLTK 리소스 설치...
call conda run -n dl_nlp_env python -m spacy download en_core_web_sm
if errorlevel 1 goto :error

call conda run -n dl_nlp_env python -c "import nltk; nltk.download('punkt'); nltk.download('punkt_tab'); nltk.download('stopwords'); nltk.download('wordnet'); nltk.download('omw-1.4'); nltk.download('vader_lexicon'); nltk.download('averaged_perceptron_tagger'); nltk.download('averaged_perceptron_tagger_eng')"
if errorlevel 1 goto :error

echo [9/9] Jupyter 커널 등록...
call conda run -n dl_nlp_env python -m ipykernel install --user --name dl_nlp_env --display-name "dl_nlp_env"
if errorlevel 1 goto :error

echo.
echo 완료되었습니다.
pause
exit /b 0

:error
echo.
echo 설치 중 오류가 발생했습니다.
pause
exit /b 1