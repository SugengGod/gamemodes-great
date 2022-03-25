/*

			     Mail include
			    BJIADOKC & Co.
	Remove this copyright, if you want to be a superman!
*/





#if defined _mail_included
	#endinput
#endif

#define _mail_included



#define MAIL_TYPE_NORMAL (0)
#define MAIL_TYPE_HTML (1)





native mail_init(host[], user[], password[], from[], sendername[]);
native mail_send(index, to[], subject[], messsage[], type = 0);
native mail_is_valid(email[]);





forward OnMailSendSuccess(index, to[], subject[], message[], type);
forward OnMailSendError(index, to[], subject[], message[], type, error[], error_code);