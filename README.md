shpak
=====

RestAPI 정의용 DSL

## 예시

```
# 예시
# @method GET
# @uri /event/{number}

object {
	
	# 1: 호빠 이벤트, 2: 룸싸롱 이벤트
	enum display_type [1, 2]; 
	 
	# 기본 이벤트 정보. 이미지 URL, 링크 URL. 버튼이미지가 노출된다면 link_value_ext1값
	$ref("/models/link.spec") link; 
	
	string theme?;
	
	# 제목
	string title?; 
	
	# 한줄문구
	string description?;
	
	enum content_type [205]; 
	
} $extends("/models/common_res.spec");

```

## 실행

> node ./cli.js ./event.spec --output dist


## 파싱결과 

```

{
  "type": "object",
  "children": [
    {
      "type": "enum",
      "name": "display_type",
      "parameters": [
        [
          1,
          2
        ]
      ],
      "comments": {
        "namedComment": {},
        "comments": [
          "1: 호빠 이벤트, 2: 룸싸롱 이벤트",
          ""
        ]
      }
    },
    {
      "type": "$ref",
      "name": "/models/link.spec",
      "isOptional": ")",
      "parameters": [
        null
      ],
      "comments": {
        "namedComment": {},
        "comments": [
          "기본 이벤트 정보. 이미지 URL, 링크 URL. 버튼이미지가 노출된다면 link_value_ext1값",
          ""
        ]
      }
    },
    {
      "type": "string",
      "name": "theme",
      "isOptional": true
    },
    {
      "type": "string",
      "name": "title",
      "isOptional": true,
      "comments": {
        "namedComment": {},
        "comments": [
          "제목",
          ""
        ]
      }
    },
    {
      "type": "string",
      "name": "description",
      "isOptional": true,
      "comments": {
        "namedComment": {},
        "comments": [
          "한줄문구",
          ""
        ]
      }
    },
    {
      "type": "enum",
      "name": "content_type",
      "parameters": [
        [
          205
        ]
      ]
    }
  ],
  "_extends": [
    "/models/common_res.spec"
  ],
  "comments": {
    "namedComment": {
      "method": "GET",
      "uri": "/event/{number}"
    },
    "comments": [
      "예시",
      ""
    ]
  }
}

```

## TODO 

HTML 문서 생성 시스템
